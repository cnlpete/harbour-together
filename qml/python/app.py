import sys, traceback
import urllib.request
import threading
import json

try:
    import pyotherside
    IS_MOBILE = True
except ImportError:
    IS_MOBILE = False

from bs4 import BeautifulSoup
import markdown
import timeago

class Main:
    def __init__(self):
        self.base_url = 'https://together.jolla.com/';
        self.network_thread = threading.Thread()
        self.network_thread.start()

    def request(self, method, url, callback, params={}):
        if self.network_thread.is_alive():
            return

        self.network_thread = threading.Thread(
            target=self._request, args=(method, url, callback, params)
        )
        self.network_thread.start()

    def _request(self, method, url, callback, params={}):
        self.log(method.upper() + ' ' + url)

        try:
            response = urllib.request.urlopen(url)
            self.log(response.getcode())
        except urllib.error.URLError as e:
            return self.log('URLError: ' + str(e.reason))

        try:
            getattr(self, callback)(response.read().decode('utf-8'), params)
        except:
            self.log(traceback.format_exc())

    def log(self, msg):
        if IS_MOBILE:
            self.send('log', msg)
        else:
            print(msg)

    def send(self, event, data):
        """
        Send data to QML objects
        """

        if IS_MOBILE:
            pyotherside.send(event, data)

    def get_questions(self, params={}):
        url = self.base_url + 'api/v1/questions/'
        if params:
            url += '?' + urllib.parse.urlencode(params)

        self.request('get', url, '_parse_questions', params)

    def _parse_questions(self, text, params):
        """
        Get questions list from public API
        """

        try:
            data = json.loads(text)
        except ValueError as e:
            return self.log('JSONError: Value is not JSON')

        out = {}

        out['questions'] = []
        for q in data['questions']:
            item = {}
            item['id'] = q['id']
            item['title'] = q['title']
            item['body'] = q['text']
            item['author_id'] = q['author']['id']
            item['author'] = q['author']['username']
            item['score'] = q['score']
            item['answer_count'] = q['answer_count']
            item['url'] = q['url']
            item['page'] = 1
            out['questions'].append(item)

        self.send('questions.finished', out)

    def get_question(self, question):
        url = self.build_url(question)
        self.request('get', url, '_parse_question', question)

    def _parse_question(self, text, question):
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

        self.send('question.finished', data)

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

    def convert_markdown(self, text):
        """
        Convert Markdown format to HTML
        """

        self.send('markdown.finished', markdown.markdown(text))

main = Main()
