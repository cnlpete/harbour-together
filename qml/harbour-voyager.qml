import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import Nemo.Notifications 1.0
import lbee.together.core 1.0
import "pages"
import "components"
import "js/utils.js" as Utils

ApplicationWindow {
    id: app

    property bool loading: false
    property bool isLoggedIn: false
    property int userId: 0
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

        function error(msg, timeout){
            previewSummary = qsTr("Error")
            previewBody = qsTr(msg)
            if (typeof timeout !== 'undefined'){
                expireTimeout = timeout
            }

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
                    if (rs && rs.id && rs.username && rs.profileUrl){
                        app.isLoggedIn = true
                        app.username = rs.username
                        app.profileUrl = rs.profileUrl
                        if (rs.avatarUrl) app.avatarUrl = rs.avatarUrl
                        if (rs.reputation) app.reputation = rs.reputation
                        if (rs.badge1) app.badge1 = rs.badge1
                        if (rs.badge2) app.badge2 = rs.badge2
                        if (rs.badge3) app.badge3 = rs.badge3
                    }
                })
            })
        }
    }

    function handleLink(link, forceExternal) {
        if (!link){
            console.log('Link is empty')
            return
        }

        link = Utils.processLink(link)

        if (!forceExternal){
            if (link.indexOf("together.jolla.com/question/") > -1){
                console.log("Internal link: " + link)
                var questionId = Utils.parseQuestionId(link)
                if (questionId){
                    pageStack.push(Qt.resolvedUrl("pages/QuestionPage.qml"), {question: {id: questionId}})
                }else{
                    console.log("Could not found question ID")
                }
            }else if (link.indexOf("together.jolla.com/users/") > -1){
                console.log("Internal link: " + link)
                pageStack.push(Qt.resolvedUrl("pages/UserPage.qml"), {user: {profile_url: link}})
            }else{
                console.log("External link: " + link)
                Qt.openUrlExternally(link)
            }
        }else{
            console.log("External link: " + link)
            Qt.openUrlExternally(link)
        }
    }
}
