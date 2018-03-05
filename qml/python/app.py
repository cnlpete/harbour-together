import sys
import urllib.request
import threading
import json

try:
    import pyotherside
    IS_MOBILE = True
except ImportError:
    IS_MOBILE = False

from bs4 import BeautifulSoup

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
            err = sys.exc_info()
            self.log(err[0].__name__ + ': ' + str(err[1]))

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

    def get_questions(self):
        url = self.base_url + 'api/v1/questions/'
        self.request('get', url, '_parse_questions')

    def _parse_questions(self, text, params):
        """
        Get questions list from public API
        """

        try:
            data = json.loads(text)
        except ValueError as e:
            return self.log('JSONError: Value is not JSON')

        questions = []
        for q in data['questions']:
            item = {}
            item['id'] = q['id']
            item['title'] = q['title']
            item['body'] = q['text']
            item['author'] = q['author']['username']
            item['score'] = q['score']
            item['answer_count'] = q['answer_count']
            item['url'] = q['url']
            questions.append(item)

        self.send('questions.finished', questions)

    def get_question(self, question):
        self.request('get', question.url, '_parse_question', question)

    def _parse_question(self, text, question):
        """
        Parse question data from html response
        """

        dom = BeautifulSoup(text, 'html.parser')

        data = {}

        # Parse question's comments
        data['comments'] = []
        comments_node = dom.find(id='comments-for-question-' + str(int(question.id)))
        if comments_node is not None:
            data['comments'] = self.parse_comment(comments_node)

        # Parse question's answers
        data['answers'] = []
        for answer_node in dom.select('div.post.answer'):
            item = {}
            item['id'] = answer_node['data-post-id']

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

            data['answers'].append(item)

        self.send('question.finished', data)

    def parse_comment(self, node):
        """
        Parse comments in a question or answer from html
        """

        data = []

        if (node is not None):
            for comment_node in node.find_all('div', class_='comment'):
                comment_body_node = comment_node.find('div', class_='comment-body')
                if comment_body_node is not None:
                    item = {}

                    item['content'] = ''
                    for p in comment_body_node.find_all(recursive=False):
                        if p.name == 'a':
                            break
                        item['content'] += str(p)

                    print(item['content'])
                    item['author'] = comment_body_node.p.find_next_sibling('a').get_text()

                    data.append(item)

        return data

main = Main()
