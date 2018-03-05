import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page{
    id: page

    property variant question

    allowedOrientations: Orientation.All

    SilicaFlickable{
        anchors.fill: parent
        contentHeight: column.height

        Column{
            id: column
            anchors {
                left: parent.left
                right: parent.right
            }

            PageHeader{
                title: question.title
            }

            Column{
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }

                Label {
                    text: question.body
                    width: parent.width
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                }

                Hr{
                    width: parent.width
                    paddingTop: Theme.horizontalPageMargin
                }

                Repeater{
                    model: ListModel{
                        id: commentModel
                    }

                    Rectangle{
                        width: parent.width
                        height: comment.height
                        color: "transparent"

                        Comment{
                            id: comment
                            dataModel: model
                            width: parent.width
                        }
                    }
                }

                CommentButton{
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    width: parent.width
                }

                Hr{
                    width: parent.width
                    paddingTop: Theme.paddingMedium
                    paddingBottom: Theme.paddingMedium
                }

                Label{
                    text: question.answer_count + " " + (qsTr("Answers"))
                    color: Theme.primaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }

                Hr{
                    width: parent.width
                    paddingTop: Theme.paddingLarge
                    paddingBottom: Theme.paddingMedium
                }

                Repeater{
                    model: ListModel{
                        id: answerModel
                    }

                    Rectangle{
                        width: parent.width
                        height: answer.height
                        color: "transparent"

                        Answer{
                            id: answer
                            dataModel: model
                            width: parent.width
                        }
                    }
                }

                AnswerButton{
                    width: parent.width
                }

                Hr{
                    width: parent.width
                }
            }
        }

        VerticalScrollDecorator{}
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
        })

        py.call('app.main.get_question', [question])
    }
}
