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

import traceback

from provider import Provider
from tools import Tools

class App:
    def __init__(self):
        self.provider = Provider()

    def get_questions(self, params={}):
        """
        Get questions list
        """

        try:
            data = self.provider.get_questions(params)
            Tools.send('questions.finished', data)
            return data
        except Exception as e:
            Tools.log(traceback.format_exc())
            Tools.send('questions.error')
            Tools.error(e.args[0])

    def get_question(self, params={}):
        """
        Get question details
        """

        try:
            data = self.provider.get_question(params)
            Tools.send('question.finished', data)
            return data
        except Exception as e:
            Tools.log(traceback.format_exc())
            Tools.send('question.error')
            Tools.error(e.args[0])

    def get_question_by_id(self, id, params={}):
        """
        Get question details by ID
        """

        try:
            data = self.provider.get_question_by_id(id, params)
            Tools.send('question.id.finished', data)
            return data
        except Exception as e:
            Tools.log(traceback.format_exc())
            Tools.send('question.error')
            Tools.error(e.args[0])

    def markdown(self, text):
        """
        Convert Markdown format to HTML
        """

        try:
            data = self.provider.markdown(text)
            Tools.send('markdown.finished', data)
            return data
        except Exception as e:
            Tools.send('markdown.error')
            Tools.error(e.args[0])

    def get_user(self, user):
        """
        Get user profile
        """

        try:
            data = self.provider.get_user(user)
            Tools.send('user.finished', data)
            return data
        except Exception as e:
            Tools.log(traceback.format_exc())
            Tools.send('user.error')
            Tools.error(e.args[0])

main = App()
