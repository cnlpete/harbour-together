import sys
import traceback
import urllib.request
import json
import re
import random
from datetime import datetime, timezone, timedelta

import markdown
import timeago
from bs4 import BeautifulSoup

from tools import Tools

BASE_URL = 'https://together.jolla.com/'
TIMEZONE = timezone(timedelta(hours=2), 'Europe/Helsinki')

class Provider:
    def __init__(self):
        self.count = 1;
        pass

    def get_questions(self, params={}):
        """
        Get questions list
        """

        url = self.build_list_url(params)

        return self.request('get', url, '_parse_questions', params)

    def markdown(self, text):
        """
        Convert Markdown text to HTML
        Also process images, links...
        """

        try:
            html = markdown.markdown(text)
            return self.convert_content(html)
        except:
            Tools.log(traceback.format_exc())
            raise Exception('Markdown convert failed')

    def get_question(self, params={}):
        """
        Get question details
        """

        url = self.build_details_url(params)

        return self.request('get', url, '_parse_question', params)

    def get_question_by_id(self, id, params={}):
        """
        Get question details by ID from API
        """

        if id:
            url = BASE_URL + 'api/v1/questions/' + str(id)
            return self.request('get', url, '_parse_question_json', params)

    def _parse_question_json(self, text, params={}):
        """
        Parse question details from API response
        """

        try:
            data = json.loads(text)
        except ValueError as e:
            Tools.log(traceback.format_exc())
            raise Exception('Could not get content')

        output = self.convert_question(data)
        output['body'] = self.markdown(output['body'])

        return output

    def _parse_question(self, text, params={}):
        """
        Parse question details from html response
        """

        dom = BeautifulSoup(text, 'html.parser')

        data = {}

        # If requested page is not first page, it mean we only need load more answers
        if params['page'] == 1:
            # Parse user info
            data['user'] = {}
            post_node = dom.select_one('div.post.question')
            if post_node is not None:
                user_node = post_node.find('div', class_='post-update-info-container')
                if user_node is not None:
                    data['user'] = self.parse_user(user_node)
                    data['user']['username'] = params['author']
                    data['user']['is_author'] = True

            # Parse question's comments
            data['comments'] = []
            comments_node = dom.find(id='comments-for-question-' + str(int(params['id'])))
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

    def build_list_url(self, params={}):
        """
        Build url for question list
        """

        url = BASE_URL + 'api/v1/questions/'
        if params:
            url += '?' + urllib.parse.urlencode(self.clean_params(params))

        return url

    def build_details_url(self, params={}):
        """
        Build url for question page details, including paging, sorting
        """

        if 'url' in params:
            url = params['url']
            url += '?page=' + str(int(params['page'])) + '&sort=' + str(params['sort'])
            return url

    def parse_answer(self, node):
        """
        Parse answers from html
        """

        data = []

        if node is not None:
            for answer_node in node.select('div.post.answer'):
                item = {}

                item['id'] = answer_node['data-post-id']

                # User info
                answer_user_node = answer_node.find('div', class_='post-update-info-container')
                if answer_user_node is not None:
                    item['user'] = self.parse_user(answer_user_node)

                # Vote count
                item['vote_count'] = 0
                item['vote_count_label'] = 0
                answer_vote_node = answer_node.find('div', id='answer-vote-number-' + str(item['id']))
                if answer_vote_node is not None:
                    item['vote_count'] = answer_vote_node.get_text()
                    item['vote_count_label'] = self.convert_count(item['vote_count'])

                # Content
                answer_info_node = answer_node.find('div', class_='post-update-info-container')
                if answer_info_node is not None:
                    item['content'] = ''
                    for p in answer_info_node.find_next_siblings():
                        style = ''
                        if p.name == 'pre':
                            style += 'white-space:normal;'
                        p['style'] = style
                        item['content'] += self.parse_content(p)

                    answer_avatar_node = answer_info_node.find('img', class_='gravatar')
                    if answer_avatar_node is not None:
                        item['avatar_url'] = 'https:' + self.get_gravatar(answer_avatar_node.get('src'), 100)

                # Parse answer's comments
                answer_comments_node = answer_node.find('div', class_='comments')
                if answer_comments_node is not None:
                    item['comments'] = self.parse_comment(answer_comments_node)

                data.append(item)

        return data

    def get_gravatar(self, source, size=100):
        """
        Return Gravatar with maximum size
        """

        return re.sub('s=(\d+)', 's=' + str(size), self.get_link(source))

    def convert_content(self, html):
        """
        Convert html to DOM for process images, links...
        Also return string processed
        """

        try:
            dom = BeautifulSoup(html, 'html.parser')
            return self.parse_content(dom)
        except:
            return html

    def parse_content(self, node):
        """
        Parse body of question, answer or comment
        """

        for image_node in node.find_all('img'):
            source = image_node.get('src')
            image_node['src'] = self.get_link(source)

        return str(node)

    def get_link(self, link):
        """
        Return validate link
        """

        if link.find('http') == 0:
            return link
        elif link.find('//') == 0:
            return 'http:' + link
        elif link.find('/') == 0:
            return BASE_URL + link
        else:
            return link

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
                        if 'class' in p.attrs and 'author' in p['class']:
                            item['author'] = p.get_text()
                        elif 'class' in p.attrs and 'age' in p['class']:
                            item['date'] = p.abbr['title']
                            item['date_ago'] = timeago.format(self.parse_date(item['date']))
                        elif p.name == 'p' or p.name == 'del':
                            item['content'] += self.parse_content(p)

                    data.append(item)

        return data

    def parse_user(self, node):
        """
        Parse user info in question or answer html
        """

        data = {}

        if node is not None:
            for post_node in node.find_all('div', class_='post-update-info'):
                card_node = post_node.find('div', class_='user-card')
                if card_node is not None:
                    date_node = post_node.find('abbr', class_='timeago')
                    if 'date' not in data.keys() and date_node is not None:
                        data['date'] = date_node.get('title')
                        data['date_ago'] = timeago.format(self.parse_date(data['date']))

                    avatar_node = card_node.find('img', class_='gravatar')
                    if 'avatar_url' not in data.keys() and avatar_node is not None:
                        data['avatar_url'] = self.get_gravatar(avatar_node.get('src'), 100)

                    info_node = card_node.find('div', class_='user-info')
                    if info_node is not None:
                        name_node = info_node.find('a', recursive=False)
                        if 'username' not in data.keys() and name_node is not None:
                            data['username'] = name_node.get_text()

                        reputation_node = info_node.find('span', class_='reputation-score')
                        if 'reputation' not in data.keys() and reputation_node is not None:
                            data['reputation'] = reputation_node.get_text()

                        if 'has_badge' not in data.keys():
                            for i in range(1, 4):
                                badge = info_node.find('span', class_='badge' + str(i))
                                if badge is not None:
                                    value = badge.find_next_sibling('span', class_='badgecount').get_text()
                                    data['badge' + str(i)] = value
                                    data['has_badge'] = True

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

        Tools.log(method.upper() + ': ' + url)

        try:
            response = urllib.request.urlopen(url)
            Tools.log('Response code: ' + str(response.getcode()))
        except:
            Tools.log(traceback.format_exc())
            raise Exception('Network request failed')

        return getattr(self, callback)(response.read().decode('utf-8'), params)

    def _parse_questions(self, text, params):
        """
        Parse questions from API response
        """

        try:
            data = json.loads(text)
        except ValueError as e:
            Tools.log(traceback.format_exc())
            raise Exception('Could not get content')

        output = {}

        #output['count'] = data['count']
        self.count += 1
        output['count'] = self.count
        output['questions'] = []
        for q in data['questions']:
            output['questions'].append(self.convert_question(q))

        return output

    def convert_question(self, q):
        """
        Convert question raw data
        """

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
        item['added_at'] = q['added_at']
        item['added_at_label'] = timeago.format(datetime.fromtimestamp(int(q['added_at']), TIMEZONE), datetime.now(TIMEZONE))
        item['last_activity'] = random.randrange(1,10,1)

        return item

    def convert_count(self, count):
        """
        Convert count number to label
        Ex: 2543 => 2k
        """

        count = int(count)
        if count >= 1000:
            return str(int(count / 1000)) + 'k'
        else:
            return str(count)
