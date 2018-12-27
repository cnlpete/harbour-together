import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: root

    allowedOrientations: Orientation.All

    SilicaWebView {
        id: webview
        anchors.fill: parent
        url: 'https://together.jolla.com/account/signin/?next=/'

        header: PageHeader {
            title: qsTr('Login')
        }

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadSucceededStatus){
                if (loadRequest.url.toString() === 'https://together.jolla.com/questions/'){
                    webview.experimental.evaluateJavaScript(root.getUserInfoScript, function(rs){
                        if (rs && rs.url.indexOf('/users/') !== -1){
                            py.call('app.api.set_logged_in_user', [{username: rs.name, profileUrl: rs.url}, true], function(success){
                                if (success){
                                    app.isLoggedIn = true
                                    app.username = rs.name
                                    app.profileUrl = rs.url
                                    pageStack.pop(undefined, PageStackAction.Immediate)
                                    pageStack.push(Qt.resolvedUrl("UserPage.qml"), {user: {username: rs.name, profile_url: rs.url}})
                                }
                            })
                        }else{
                            notification.error(qsTr("Could not login. Please try again."))
                            pageStack.pop()
                        }
                    })
                }
            }
        }
    }

    property string getUserInfoScript: "(function(){
var userDiv = document.getElementById('userToolsNav')
var aList = userDiv.getElementsByTagName('a')
if (aList.length){
    for (var i=0; i<aList.length; i++){
        if (i === 0){
            return {url: aList[0].getAttribute('href'), name: aList[0].innerHTML}
        }
    }
}
})()"
}
