import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import Nemo.Notifications 1.0
import lbee.together.core 1.0
import "pages"
import "components"

ApplicationWindow {
    id: app

    property Page mainPage
    property bool loading: false
    property bool isLoggedIn: false

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    initialPage: Qt.resolvedUrl("pages/QuestionsPage.qml")

    Component.onCompleted: {
        app.isLoggedIn = !!settings.sessionId
    }

    FontLoader {
        id: iconFont
        source: "fonts/fa-solid-900.ttf"
    }

    Settings {
        id: settings
        onSessionIdChanged: {
            app.isLoggedIn = !!settings.sessionId
        }
    }

    Notification {
        id: notification

        function error(msg){
            previewSummary = qsTr("Error")
            previewBody = qsTr(msg)
            publish()
        }
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'))

            setHandler('log', function(msg){
                console.log(msg)
            })

            setHandler('error', function(msg){
                notification.error(qsTr(msg))
            })

            importModule('app', function(){})
        }
    }

    function refresh(){
        moveToMainPage()
        mainPage.refresh()
        loading = mainPage.loading
    }

    function moveToMainPage(){
        if (pageStack.currentPage != mainPage){
            pageStack.pop(mainPage, PageStackAction.Immediate)
        }
    }
}
