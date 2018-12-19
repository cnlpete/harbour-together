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

    Component.onCompleted: {
        mainPage = pageStack.push(Qt.resolvedUrl("pages/QuestionsPage.qml"))
    }

    FontLoader {
        id: iconFont
        source: "fonts/fa-solid-900.ttf"
    }

    Settings {
        id: settings
    }

    Notification {
        id: notification
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'))

            setHandler('log', function(msg){
                console.log(msg)
            })

            setHandler('error', function(msg){
                notification.previewSummary = qsTr("Error")
                notification.previewBody = msg
                notification.publish()
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
