try:
    import pyotherside
    IS_MOBILE = True
except ImportError:
    IS_MOBILE = False

class Tools:
    @staticmethod
    def log(str):
        """
        Print log to console
        """

        Tools.send('log', str)

    @staticmethod
    def error(str):
        """
        Send error string to QML to show on banner
        """

        Tools.send('error', str)

    @staticmethod
    def send(event, msg=None):
        """
        Send data to QML
        """

        if IS_MOBILE:
            pyotherside.send(event, msg)
        else:
            print(event + ': ' + msg)
