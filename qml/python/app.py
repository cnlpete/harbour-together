import timeago

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
        except Exception as e:
            Tools.send('questions.error')
            Tools.error(e.args[0])

    def get_question(self, question):
        """
        Get question details
        """

        try:
            data = self.provider.get_question(question)
            Tools.send('question.finished', data)
        except Exception as e:
            Tools.send('question.error')
            Tools.error(e.args[0])

    def markdown(self, text):
        """
        Convert Markdown format to HTML
        """

        try:
            data = self.provider.markdown(text)
            Tools.send('markdown.finished', data)
        except Exception as e:
            Tools.send('markdown.error')
            Tools.error(e.args[0])

main = App()
