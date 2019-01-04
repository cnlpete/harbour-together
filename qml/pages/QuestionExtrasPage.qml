import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

Page {
    id: root

    property var question: ({})
    property bool following: false
    property int followers: 0

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            spacing: Theme.paddingSmall
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.rightMargin: Theme.horizontalPageMargin

            PullDownMenu {
                MenuItem {
                    text: qsTr("View in browser")
                    onClicked: {
                        handleLink(question.url, true)
                    }
                }
            }

            QuestionTitle {
                text: question.title || ''
                width: parent.width
                paddingTop: Theme.horizontalPageMargin
            }

            SectionHeader {
                text: qsTr("Question tools")
                x: 0
            }

            Button {
                id: followBtn

                property bool loading: false

                text: !loading ? (following ? qsTr('\uf00c Following') : qsTr('Follow')) : ''
                anchors.horizontalCenter: parent.horizontalCenter
                visible: app.isLoggedIn
                onClicked: {
                    if (loading) return
                    loading = true

                    py.call('app.api.do_follow', [question.id], function(rs){
                        loading = false

                        if (rs.success === 1){
                            following = !rs.status
                            followers = rs.count
                        }
                    })
                }

                BusyIndicator {
                    running: true
                    visible: followBtn.loading
                    size: BusyIndicatorSize.Small
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Label {
                text: qsTr("%1 followers").arg(followers)
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            SectionHeader {
                text: qsTr("Public thread")
                x: 0
                visible: false
            }

            Label {
                text: "This thread is public, all members of Together.Jolla.Com can read this page."
                width: parent.width
                wrapMode: Text.WordWrap
                visible: false
            }

            SectionHeader {
                text: qsTr("Stats")
                x: 0
            }

            QuestionStat {
                label: qsTr("Asked")
                value: question.added_at_label
                width: parent.width
            }

            QuestionStat {
                label: qsTr("Seen")
                value: qsTr("%1 times").arg(question.view_count)
                width: parent.width
            }

            QuestionStat {
                label: qsTr("Voted")
                value: qsTr("%1 times").arg(question.score)
                width: parent.width
            }

            QuestionStat {
                label: qsTr("Answered")
                value: qsTr("%1 times").arg(question.answer_count)
                width: parent.width
            }

            QuestionStat {
                label: qsTr("Last updated")
                value: question.last_activity_label
                width: parent.width
            }

            SectionHeader {
                text: qsTr("Related questions")
                x: 0
                visible: listView.count
            }

            ListView {
                id: listView
                width: parent.width + 2 * Theme.horizontalPageMargin
                x: -1 * Theme.horizontalPageMargin
                interactive: false
                height: count > 0 ? contentHeight : 0

                model: ListModel {
                    id: relatedQuestions
                }

                delegate: BackgroundItem {
                    width: listView.width
                    height: questionTitle.height + 2 * Theme.horizontalPageMargin

                    Label {
                        id: questionTitle
                        text: Utils.processQuestionTitle(title)
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: Theme.horizontalPageMargin
                        anchors.rightMargin: Theme.horizontalPageMargin
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                    }

                    onClicked: handleLink(url)
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: {
        if (question.followers){
            followers = question.followers
        }
        if (question.following){
            following = question.following
        }
        if (question.related){
            for (var i=0; i<question.related.length; i++){
                relatedQuestions.append(question.related[i])
            }
        }
    }
}
