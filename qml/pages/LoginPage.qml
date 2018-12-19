import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    allowedOrientations: Orientation.All

    SilicaWebView {
        id: webview
        anchors.fill: parent
        url: 'https://together.jolla.com/account/signin/'

        header: PageHeader {
            title: qsTr('Login')
        }

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadSucceededStatus){
                if (loadRequest.url.toString() === 'https://together.jolla.com/questions/'){
                    py.call('app.api.do_login', [])
                    pageStack.pop()
                }
            }
        }
    }
}
