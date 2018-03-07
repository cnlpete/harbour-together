import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    property variant question
    property variant userModel

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

                    BusyIndicator {
                        id: busyIndicator
                        running: true
                        size: BusyIndicatorSize.Small
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: qsTr("Loading anwsers...")
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
                    }

                    Hr {
                        width: parent.width
                        paddingTop: Theme.paddingMedium
                        paddingBottom: Theme.paddingMedium
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
                        paddingTop: Theme.paddingLarge
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
                    }

                    Hr {
                        width: parent.width
                    }
                }
            }
        }

        VerticalScrollDecorator {}
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
        })

        py.call('app.main.get_question', [question])
    }
}
