import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

Page {
    property variant question
    property int question_id
    property int p: 1
    property string sort: "votes"
    property bool loading: false


    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
            }

            PullDownMenu {
                MenuItem {
                    text: qsTr("View in browser")
                    onClicked: {
                        Utils.handleLink(question.url, true)
                    }
                }
            }

            PageHeader {
                title: question ? question.title : ""
            }

            Column {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Label {
                    text: question ? question.body : ""
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    textFormat: Text.StyledText
                    linkColor: Theme.highlightColor
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.paddingMedium
                    }
                    onLinkActivated: Utils.handleLink(link)
                }

                Row {
                    visible: !usersModel.count
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Theme.paddingSmall
                    height: busyIndicator.height + 2 * Theme.paddingLarge

                    Image {
                        visible: !busyIndicator.visible
                        source: "image://theme/icon-s-high-importance"
                        width: Theme.iconSizeSmall
                        height: Theme.iconSizeSmall
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    BusyIndicator {
                        id: busyIndicator
                        running: true
                        size: BusyIndicatorSize.Small
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: {
                            if (question){
                                busyIndicator.visible ? qsTr("Loading anwsers") + "..." : qsTr("Failed")
                            }else if(question_id){
                                busyIndicator.visible ? qsTr("Loading question") + "..." : qsTr("Failed")
                            }
                        }
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Column {
                    width: parent.width
                    visible: !!usersModel.count

                    Hr {
                        width: parent.width
                    }

                    Repeater {
                        model: ListModel {
                            id: usersModel
                        }

                        Rectangle {
                            width: parent.width
                            height: userInfo.height + Theme.horizontalPageMargin
                            color: "transparent"

                            UserInfo {
                                id: userInfo
                                dataModel: model
                                anchors {
                                    left: parent.left
                                    leftMargin: Theme.horizontalPageMargin
                                    right: parent.right
                                    rightMargin: Theme.horizontalPageMargin
                                }
                            }

                            Hr {
                                width: parent.width
                                anchors.top: userInfo.bottom
                            }
                        }
                    }

                    Repeater {
                        model: ListModel {
                            id: commentModel
                        }

                        Rectangle {
                            width: parent.width
                            height: comment.height + commentHr.height
                            color: "transparent"

                            Comment {
                                id: comment
                                dataModel: model
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.paddingMedium

                                Hr {
                                    id: commentHr
                                    width: parent.width
                                    opacity: 0.4
                                    paddingTop: Theme.paddingMedium
                                    paddingBottom: Theme.paddingMedium
                                    anchors.top: comment.bottom
                                    anchors.left: comment.left
                                    visible: index < commentModel.count - 1
                                }
                            }
                        }
                    }

                    CommentButton {
                        visible: false
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
                        anchors.right: parent.right
                        padding: Theme.paddingMedium
                        onClicked: {
                            var url = question.url + '#comments-for-question-' + question.id
                            Utils.handleLink(url, true)
                        }
                    }

                    Hr {
                        width: parent.width
                        paddingBottom: Theme.paddingLarge
                    }

                    Label {
                        text: question ? (question.answer_count + " " + (qsTr("Answers"))) : ""
                        color: Theme.primaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin
                    }

                    Hr {
                        width: parent.width
                        paddingTop: Theme.paddingLarge
                    }

                    Repeater {
                        model: ListModel {
                            id: answerModel
                        }

                        Rectangle {
                            width: parent.width - Theme.paddingSmall
                            height: answer.height
                            color: "transparent"

                            Answer {
                                id: answer
                                dataModel: model
                                questionModel: question
                                width: parent.width
                            }
                        }
                    }

                    AnswerButton {
                        width: parent.width
                        padding: Theme.paddingMedium
                        onClicked: {
                            var url = question.url + "#fmanswer"
                            Utils.handleLink(url, true)
                        }
                    }

                    Hr {
                        width: parent.width
                        paddingTop: Theme.paddingMedium
                        opacity: 0
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        PushUpMenu {
            id: pushUpMenu
            visible: false

            MenuItem {
                text: loading ? qsTr("Loading...") : qsTr("Load more")
                onClicked: {
                    if (!loading){
                        pushUpMenu.busy = true
                        p += 1
                        refresh()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        py.setHandler('question.finished', function(rs){
            if (rs.comments){
                for (var i=0; i<rs.comments.length; i++){
                    commentModel.append(rs.comments[i])
                }
            }

            if (rs.answers){
                for (var i=0; i<rs.answers.length; i++){
                    answerModel.append(rs.answers[i])
                }
            }

            if (rs.users){
                for (var i=0; i<rs.users.length; i++){
                    console.log(JSON.stringify(rs.users[i]))
                    usersModel.append(rs.users[i])
                }
            }

            if (rs.has_pages){
                pushUpMenu.visible = true
            }else{
                pushUpMenu.visible = false
            }

            pushUpMenu.busy = false
            loading = false
        })

        py.setHandler('question.id.finished', function(rs){
            if (rs){
                question = rs
                refresh()
            }
        })

        py.setHandler('question.error', function(){
            busyIndicator.visible = false
            loading = false
        })

        refresh()
    }

    function refresh(){
        if (question){
            loading = true
            py.call('app.main.get_question', [{
                                                  id: question.id,
                                                  url: question.url,
                                                  author: question.author,
                                                  page: p,
                                                  sort: sort
                                              }])
        }else if (question_id){
            py.call("app.main.get_question_by_id", [question_id])
        }
    }
}
