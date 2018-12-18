"""
Copyright (C) 2018 Nguyen Long.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

import sys
import traceback
import urllib.request
import json
import re
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
            url = BASE_URL + 'api/v1/questions/' + str(int(id))
            return self.request('get', url, '_parse_question_json', params)

    def get_user(self, user):
        """
        Get user profile from website
        """

        if 'info_url' in user:
            url = user['info_url']
        else:
            url = BASE_URL + 'users/' + user['id'] + '/' + user['username'].lower()

        return self.request('get', url, '_parse_user_profile', user)

    def _parse_user_profile(self, html, user):
        """
        Parse user profile from html response
        """

        dom = BeautifulSoup(html, 'html.parser')
        data = {}

        avartar_node = dom.find('img', class_='gravatar')
        if avartar_node is not None:
            data['avartar_url'] = self.get_link(avartar_node.get('src'))

        score_node = dom.find('div', class_='scoreNumber')
        if score_node is not None:
            data['score'] = score_node.get_text()

        user_details_table = dom.find('table', class_='user-details')
        if user_details_table is not None:
            for tr in user_details_table.find_all('tr'):
                raw_text = tr.get_text()
                if raw_text.find('member since') != -1:
                    created_node = tr.find('abbr', class_='timeago')
                    if created_node is not None:
                        created_datetime = self._parse_datetime(created_node.get('title'))
                        data['created'] = created_datetime.strftime('%Y-%m-%d')
                elif raw_text.find('last seen') != -1:
                    last_seen_node = tr.find('abbr', class_='timeago')
                    if last_seen_node is not None:
                        last_seen_datetime = self._parse_datetime(last_seen_node.get('title'))
                        data['last_seen'] = last_seen_datetime.strftime('%Y-%m-%d')
                        data['last_seen_label'] = timeago.format(last_seen_datetime, datetime.now(TIMEZONE))

        questions_a_node = dom.find('a', attrs={'name': 'questions'})
        if questions_a_node is not None:
            questions_h2_node = questions_a_node.find_next('h2')
            if questions_h2_node.name == 'h2':
                questions_count_node = questions_h2_node.find('span', class_='count')
                if questions_count_node is not None:
                    data['questions_count'] = int(questions_count_node.get_text())

        data['questions'] = []
        for question_node in dom.find_all('div', class_='short-summary'):
            question = self._parse_question_html(question_node)
            if question:
                data['questions'].append(question)

        return data

    def _parse_question_html(self, node):
        """
        Parse question data from DOM node
        """

        if node is None:
            return None

        data = {}
        data['id'] = int(node.get('id').replace('question-', ''))
        h2_node = node.find('h2')
        if h2_node is not None:
            a_node = h2_node.find('a')
            if a_node is not None:
                data['title'] = a_node.get_text()
                data['url'] = self.get_link(a_node.get('href'))

        view_count_node = node.find('div', class_='views')
        if view_count_node is not None:
            view_count_value = view_count_node.find('span', class_='item-count').get_text()
            data['view_count_label'] = '0' if view_count_value == 'no' else view_count_value

        score_count_node = node.find('div', class_='votes')
        if score_count_node is not None:
            score_count_value = score_count_node.find('span', class_='item-count').get_text()
            data['score_label'] = '0' if score_count_value == 'no' else score_count_value

        answer_count_node = node.find('div', class_='answers')
        if answer_count_node is not None:
            answer_count_value = answer_count_node.find('span', class_='item-count').get_text()
            data['answer_count_label'] = '0' if answer_count_value == 'no' else answer_count_value

        return data

    def _parse_datetime(self, string):
        """
        Parse datetime string. Ex: 2014-11-22 13:44:23 +0200
        """

        return datetime.strptime(string, '%Y-%m-%d %H:%M:%S %z')

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
            data['users'] = []
            post_node = dom.select_one('div.post.question')
            if post_node is not None:
                user_node = post_node.find('div', class_='post-update-info-container')
                if user_node is not None:
                    data['users'] = self.parse_user(user_node)
                    #user['username'] = params['author']
                    #user['is_author'] = True

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

        # Parse question's extras
        favorite_node = dom.find('div', attrs={'id': 'favorite-number'})
        if favorite_node is not None:
            data['followers'] = favorite_node.get_text().strip()

        data['related'] = []
        related_nodes = dom.find('div', class_='questions-related')
        if related_nodes is not None:
            for related_node in related_nodes.select('p'):
                a_node = related_node.find('a')
                item = {}
                item['title'] = a_node.get_text()
                item['url'] = self.get_link(a_node.get('href'))
                data['related'].append(item)

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
                    item['users'] = self.parse_user(answer_user_node)

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
            return BASE_URL + link.strip('/')
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
                            item['author_url'] = self.get_link(p.get('href'))
                        elif 'class' in p.attrs and 'age' in p['class']:
                            item['date'] = p.abbr['title']
                            item['date_ago'] = timeago.format(self._parse_datetime(item['date']), datetime.now(TIMEZONE))
                        elif p.name == 'p' or p.name == 'del':
                            item['content'] += self.parse_content(p)

                    data.append(item)

        return data

    def parse_user(self, node):
        """
        Parse user info in question or answer html
        """

        data = []

        if node is not None:
            idx = 0
            for post_node in node.find_all('div', class_='post-update-info'):
                item = {
                    'username': '',
                    'info_url': '',
                    'is_wiki': False,
                    'asked': False, 'answered': False, 'updated': False,
                    'date': '', "date_ago": '',
                    'avatar_url': '',
                    'reputation': '', 'badge1': '', 'badge2': '', 'badge3': ''
                }

                raw_text = post_node.get_text()
                if raw_text.find('asked') != -1:
                    item['asked'] = True
                elif raw_text.find('answered') != -1:
                    item['answered'] = True
                elif raw_text.find('updated') != -1:
                    item['updated'] = True

                card_node = post_node.find('div', class_='user-card')
                if card_node is not None:
                    date_node = post_node.find('abbr', class_='timeago')
                    if date_node is not None:
                        item['date'] = date_node.get('title')
                        item['date_ago'] = timeago.format(self._parse_datetime(item['date']), datetime.now(TIMEZONE))

                    avatar_node = card_node.find('img', class_='gravatar')
                    if avatar_node is not None:
                        item['avatar_url'] = self.get_gravatar(avatar_node.get('src'), 100)

                    info_node = card_node.find('div', class_='user-info')
                    if info_node is not None:
                        name_node = info_node.find('a', recursive=False)
                        if name_node is not None:
                            item['username'] = name_node.get_text()
                            item['info_url'] = self.get_link(name_node.get('href'))

                        reputation_node = info_node.find('span', class_='reputation-score')
                        if reputation_node is not None:
                            item['reputation'] = reputation_node.get_text()

                        for i in range(1, 4):
                            badge = info_node.find('span', class_='badge' + str(i))
                            if badge is not None:
                                value = badge.find_next_sibling('span', class_='badgecount').get_text()
                                item['badge' + str(i)] = value
                                item['has_badge'] = True
                else:
                    if item['updated']:
                        date_node = post_node.find('abbr', class_='timeago')
                        if date_node is not None:
                            item['date'] = date_node.get('title')
                            item['date_ago'] = timeago.format(self._parse_datetime(item['date']), datetime.now(TIMEZONE))

                        if idx == 1:
                            item['username'] = data[0]['username']
                            item['avatar_url'] = data[0]['avatar_url']
                            item['info_url'] = data[0]['info_url']
                            item['reputation'] = data[0]['reputation']
                            item['has_badge'] = data[0]['has_badge']
                            item['badge1'] = data[0]['badge1']
                            item['badge2'] = data[0]['badge2']
                            item['badge3'] = data[0]['badge3']
                    else:
                        wiki_img_node = post_node.find('img', alt='this post is marked as community wiki')
                        if wiki_img_node is not None:
                            item['is_wiki'] = True
                            item['avatar_url'] = self.get_link(wiki_img_node.get('src'))
                            date_node = post_node.find('abbr', class_='timeago')
                            if date_node is not None:
                                item['date'] = date_node.get('title')
                                item['date_ago'] = timeago.format(self._parse_datetime(item['date']), datetime.now(TIMEZONE))

                data.append(item)
                idx += 1

        return data

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

        output['count'] = data['count']
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
        item['last_activity'] = q['last_activity_at']
        item['last_activity_label'] = timeago.format(datetime.fromtimestamp(int(q['last_activity_at']), TIMEZONE), datetime.now(TIMEZONE))

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
