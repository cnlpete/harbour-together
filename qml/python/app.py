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
        except Exception as e:
            Tools.send('markdown.error')
            Tools.error(e.args[0])

main = App()
