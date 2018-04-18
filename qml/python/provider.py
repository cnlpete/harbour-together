import sys
import traceback
import urllib.request
import json

import markdown
import timeago
from bs4 import BeautifulSoup

from tools import Tools

BASE_URL = 'https://together.jolla.com/'

class Provider:
    def __init__(self):
        pass

    def get_questions(self, params = {}):
        """
        Get questions list
        """

        url = BASE_URL + 'api/v1/questions/'
        if params:
            url += '?' + urllib.parse.urlencode(self.clean_params(params))

        return self.request('get', url, 'parse_questions', params)

    def markdown(self, text):
        """
        Convert Markdown text to HTML
        """

        try:
            return markdown.markdown(text)
        except:
            Tools.log(traceback.format_exc())
            raise Exception('Markdown convert failed')

    def get_question(self, question):
        """
        Get question details
        """

        url = self.build_url(question)

        return self.request('get', url, 'parse_question', question)

    def parse_question(self, text, question):
        """
        Parse question data from html response
        """

        dom = BeautifulSoup(text, 'html.parser')

        data = {}

        # If requested page is not first page, it mean we only need load more answers
        if question.page == 1:
            # Parse user info
            data['user'] = {}
            post_node = dom.select_one('div.post.question')
            if post_node is not None:
                user_node = post_node.find('div', class_='post-update-info-container')
                if user_node is not None:
                    data['user'] = self.parse_user(user_node)
                    data['user']['username'] = question.author
                    data['user']['is_author'] = True

            # Parse question's comments
            data['comments'] = []
            comments_node = dom.find(id='comments-for-question-' + str(int(question.id)))
            if comments_node is not None:
                data['comments'] = self.parse_comment(comments_node)

        # Parse question paging
        data['has_pages'] = 0
        paging_node = dom.find('div', class_='paginator')
        if paging_node is not None:
            current_page_node = paging_node.find('span', class_='curr')
            if current_page_node is not None:
                data['page'] = current_page_node.get_text().strip()
            else:
                data['page'] = 1

            next_page_node = paging_node.find('span', class_='next')
            if next_page_node is not None:
                data['has_pages'] = 1

        # Parse question's answers
        data['answers'] = self.parse_answer(dom)

        return data

    def build_url(self, question):
        """
        Build url for question page, including paging, sort
        """

        url = question.url

        url += '?page=' + str(int(question.page))

        return url

    def parse_answer(self, node):
        data = []

        if node is not None:
            for answer_node in node.select('div.post.answer'):
                item = {}

                item['id'] = answer_node['data-post-id']
                answer_user_node = answer_node.find('div', class_='post-update-info-container')
                if answer_user_node is not None:
                    item['user'] = self.parse_user(answer_user_node)

                answer_info_node = answer_node.find('div', class_='post-update-info-container')
                if answer_info_node is not None:
                    item['content'] = ''
                    for p in answer_info_node.find_next_siblings():
                        style = ''
                        if p.name == 'pre':
                            style += 'white-space:normal;'
                        p['style'] = style
                        item['content'] += str(p)

                    answer_avatar_node = answer_info_node.find('img', class_='gravatar')
                    if answer_avatar_node is not None:
                        item['avatar_url'] = 'http:' + answer_avatar_node.get('src')

                # Parse answer's comments
                answer_comments_node = answer_node.find('div', class_='comments')
                if answer_comments_node is not None:
                    item['comments'] = self.parse_comment(answer_comments_node)

                data.append(item)

        return data

    def parse_comment(self, node):
        """
        Parse comments in a question or answer from html
        """

        data = []

        if node is not None:
            for comment_node in node.find_all('div', class_='comment'):
                comment_body_node = comment_node.find('div', class_='comment-body')
                if comment_body_node is not None:
                    item = {}

                    item['content'] = ''
                    for p in comment_body_node.find_all(recursive=False):
                        if p.name == 'a':
                            item['author'] = p.get_text()
                            break
                        item['content'] += str(p).strip()

                    data.append(item)

        return data

    def parse_user(self, node):
        """
        Parse user info in question or answer html
        """

        data = {}

        if node is not None:
            node1 = node.find('div', class_='post-update-info')
            if node1 is not None:
                date_node = node1.find('abbr', class_='timeago')
                if date_node is not None:
                    data['date'] = date_node.get('title')
                    data['date_ago'] = timeago.format(self.parse_date(data['date']))

                card_node = node1.find('div', class_='user-card')
                if card_node is not None:
                    avatar_node = card_node.find('img', class_='gravatar')
                    if avatar_node is not None:
                        data['avatar_url'] = 'http:' + avatar_node.get('src')

                    info_node = card_node.find('div', class_='user-info')
                    if info_node is not None:
                        name_node = info_node.find('a', recursive=False)
                        if name_node is not None:
                            data['username'] = name_node.get_text()

                        reputation_node = info_node.find('span', class_='reputation-score')
                        if reputation_node is not None:
                            data['reputation'] = reputation_node.get_text()

                        for i in range(1, 4):
                            badge = info_node.find('span', class_='badge' + str(i))
                            if badge is not None:
                                value = badge.find_next_sibling('span', class_='badgecount').get_text()
                                data['badge' + str(i)] = value

        return data

    def parse_date(self, date):
        """
        Return datetime format supportted by "timeago" lib, strip timezone data
        Ex: 2018-03-09 09:45:54 +0200 => 2018-03-09 09:45:54
        """

        return ' '.join(date.split(' ')[:-1])

    def clean_params(self, params={}):
        """
        Clean empty param
        """

        new_params = {}
        for key, value in params.items():
            if value != '':
                new_params[key] = value

        return new_params

    def request(self, method, url, callback, params={}):
        """
        Perform network request
        """

        Tools.log(method.upper() + ' ' + url)

        try:
            response = urllib.request.urlopen(url)
            Tools.log('Response code: ' + str(response.getcode()))
        except:
            Tools.log(traceback.format_exc())
            raise Exception('Network request failed')

        return getattr(self, callback)(response.read().decode('utf-8'), params)

    def parse_questions(self, text, params):
        """
        Parse questions from API response
        """

        try:
            data = json.loads(text)
        except ValueError as e:
            Tools.log(traceback.format_exc())
            raise Exception('Could not get content')

        output = {}

        output['questions'] = []
        for q in data['questions']:
            item = {}
            item['id'] = q['id']
            item['title'] = q['title']
            item['body'] = q['text']
            item['author_id'] = q['author']['id']
            item['author'] = q['author']['username']
            item['url'] = q['url']
            item['score'] = q['score']
            item['score_label'] = self.convert_count(q['score'])
            item['answer_count'] = q['answer_count']
            item['answer_count_label'] = self.convert_count(q['answer_count'])
            item['view_count'] = q['view_count']
            item['view_count_label'] = self.convert_count(q['view_count'])
            item['page'] = 1

            output['questions'].append(item)

        return output

    def convert_count(self, count):
        """
        Convert count number to label
        Ex: 2543 => 2k
        """

        if count >= 1000:
            return str(int(count / 1000)) + 'k'
        else:
            return str(count)
