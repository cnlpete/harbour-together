import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import Nemo.Notifications 1.0
import lbee.together.core 1.0
import "pages"
import "components"

ApplicationWindow {
    id: app

    property bool loading: false
    property bool isLoggedIn: false
    property string username: ''
    property string profileUrl: ''
    property string avatarUrl: ''
    property int reputation: 0
    property int badge1: 0
    property int badge2: 0
    property int badge3: 0

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    initialPage: Qt.resolvedUrl("pages/QuestionsPage.qml")

    FontLoader {
        id: iconFont
        source: "fonts/fa-solid-900.ttf"
    }

    Settings {
        id: settings
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

            importModule('app', function(){
                py.call('app.api.get_logged_in_user', [], function(rs){
                    if (rs){
                        app.isLoggedIn = true
                        app.username = rs.username
                        app.profileUrl = rs.profileUrl
                        app.avatarUrl = rs.avatarUrl
                        if (rs.reputation) app.reputation = rs.reputation
                        if (rs.badge1) app.badge1 = rs.badge1
                        if (rs.badge2) app.badge2 = rs.badge2
                        if (rs.badge3) app.badge3 = rs.badge3
                    }
                })
            })
        }
    }
}
