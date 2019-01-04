import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: root

    property var user: ({})
    property bool loading: true
    property bool hasError: false

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu {
            MenuItem {
                text: qsTr("View in browser")
                onClicked: {
                    handleLink(user.profile_url, true)
                }
            }

            MenuItem {
                text: qsTr("Logout")
                onClicked: {
                    app.isLoggedIn = false
                    app.username = ''
                    app.profileUrl = ''
                    app.avatarUrl = ''
                    app.reputation = 0
                    app.badge1 = 0
                    app.badge2 = 0
                    app.badge3 = 0
                    py.call('app.api.do_logout')
                    pageStack.pop()
                }
                visible: user.username === app.username
            }
        }

        Column {
            id: content
            visible: !loading && !hasError
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                id: pageHeader
                title: user.username || ""
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium

                Rectangle {
                    id: avartarElm
                    width: Theme.iconSizeExtraLarge
                    height: width
                    color: "transparent"

                    Image {
                        id: avartar
                        anchors.fill: parent
                    }
                }

                Column {
                    width: parent.width - avartarElm.width

                    QuestionStat {
                        id: created
                        label: qsTr('Member since')
                        width: parent.width
                    }

                    QuestionStat {
                        id: last_seen
                        label: qsTr('Last seen')
                        width: parent.width
                    }

                    QuestionStat {
                        id: score
                        label: qsTr('Karma')
                        width: parent.width
                    }
                }
            }

            SectionHeader {
                id: question_section

                property int count: 0

                text: qsTr('%1 Questions').arg(count)
            }

            ListView {
                id: questionsListView
                interactive: false
                width: parent.width
                height: count > 0 ? contentHeight : 0

                model: ListModel {
                    id: questionsModel
                }

                delegate: QuestionDelegate {
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Loading {
        id: busy
        loading: root.loading
        hasError: root.hasError
        text: qsTr("\uf007 %1").arg(user.username || qsTr('Loading...'))
        anchors.fill: parent
    }

    Component.onCompleted: {
        py.setHandler('user.error', function(){
            loading = false
            hasError = true
            busy.text = qsTr("Could not load data")
        })

        py.call('app.api.get_user', [user], function(rs){
            loading = false

            if (!rs) return

            if (app.isLoggedIn && rs.current_user){
                var currentUser = rs.current_user

                if (rs.avatarUrl && rs.username === currentUser.username){
                    currentUser.avatarUrl = rs.avatarUrl
                    app.avatarUrl = rs.avatarUrl
                }
                if (currentUser.reputation) app.reputation = currentUser.reputation
                if (currentUser.badge1) app.badge1 = currentUser.badge1
                if (currentUser.badge2) app.badge2 = currentUser.badge2
                if (currentUser.badge3) app.badge3 = currentUser.badge3

                py.call('app.api.set_logged_in_user', [currentUser])
            }

            if (rs.username){
                pageHeader.title = rs.username
            }
            if (rs.avatarUrl){
                avartar.source = rs.avatarUrl
            }
            if (rs.created_label){
                created.value = rs.created_label
            }
            if (rs.last_seen_label){
                last_seen.value = rs.last_seen_label
            }
            if (rs.reputation){
                score.value = rs.reputation
            }
            if (rs.questions_count){
                question_section.count = rs.questions_count
            }
            if (rs.questions && rs.questions.length){
                for (var i=0; i<rs.questions.length; i++){
                    questionsModel.append(rs.questions[i])
                }
            }
        })
    }
}
