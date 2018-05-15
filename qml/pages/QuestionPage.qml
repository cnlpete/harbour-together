import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    property variant question
    property variant userModel
    property int p: 1
    property string sort: "votes"


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

            PageHeader {
                title: question.title
            }

            Column {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Label {
                    text: question.body
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
                }

                Row {
                    visible: !userModel
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
                        text: busyIndicator.visible ? qsTr("Loading anwsers") + "..." : qsTr("Failed")
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Column {
                    width: parent.width
                    visible: !!userModel

                    Hr {
                        width: parent.width
                        paddingTop: Theme.horizontalPageMargin
                    }

                    UserInfo {
                        dataModel: userModel
                        anchors {
                            left: parent.left
                            leftMargin: Theme.horizontalPageMargin
                            right: parent.right
                            rightMargin: Theme.horizontalPageMargin
                        }
                    }

                    Hr {
                        width: parent.width
                        paddingTop: Theme.horizontalPageMargin
                    }

                    Repeater {
                        model: ListModel {
                            id: commentModel
                        }

                        Rectangle {
                            width: parent.width
                            height: comment.height
                            color: "transparent"

                            Comment {
                                id: comment
                                dataModel: model
                                width: parent.width
                            }
                        }
                    }

                    CommentButton {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
                        anchors.right: parent.right
                        padding: Theme.paddingMedium
                    }

                    Hr {
                        width: parent.width
                        paddingTop: Theme.paddingMedium
                        paddingBottom: 2 * Theme.paddingMedium
                    }

                    Label {
                        text: question.answer_count + " " + (qsTr("Answers"))
                        color: Theme.primaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin
                    }

                    Hr {
                        width: parent.width
                        paddingTop: 2 * Theme.paddingLarge
                    }

                    Repeater {
                        model: ListModel {
                            id: answerModel
                        }

                        Rectangle {
                            width: parent.width
                            height: answer.height
                            color: "transparent"

                            Answer {
                                id: answer
                                dataModel: model
                                width: parent.width
                            }
                        }
                    }

                    AnswerButton {
                        width: parent.width
                        padding: Theme.paddingMedium
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
                text: qsTr("Load more")
                onClicked: {
                    p += 1
                    refresh()
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
            if (rs.user){
                userModel = rs.user
            }
            if (rs.has_pages){
                pushUpMenu.visible = true
            }else{
                pushUpMenu.visible = false
            }
        })

        py.setHandler('question.error', function(){
            busyIndicator.visible = false
        })

        refresh()
    }

    function refresh(){
        py.call('app.main.get_question', [{
                                              id: question.id,
                                              url: question.url,
                                              author: question.author,
                                              page: p,
                                              sort: sort
                                          }])
    }
}
