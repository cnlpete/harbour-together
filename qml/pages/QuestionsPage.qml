import QtQuick 2.0
import Sailfish.Silica 1.0
import lbee.together.core 1.0

Page {
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        anchors.fill: parent

        model: ListModel {
            id: listModel
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
            }

            MenuItem {
                text: {
                    var label = qsTr("Sort by") + ": "
                    switch (settings.order){
                    case Settings.Date:
                        label += qsTr("Date")
                        break;
                    case Settings.Activity:
                        label += qsTr("Activity")
                        break;
                    case Settings.Answers:
                        label += qsTr("Answers")
                        break;
                    case Settings.Votes:
                        label += qsTr("Votes")
                        break;
                    }

                    return label
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SortPage.qml"))
                }
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    listModel.clear()
                    py.call('app.main.get_questions')
                }
            }
        }

        header: PageHeader {
            title: qsTr("Questions")
        }

        delegate: BackgroundItem {
            id: delegate
            height: titleLbl.height + authorLbl.height + Theme.horizontalPageMargin

            Column {
                anchors {
                    fill: parent
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    topMargin: Theme.horizontalPageMargin / 2
                    bottomMargin: Theme.horizontalPageMargin / 2
                }

                Label {
                    id: titleLbl
                    text: title
                    width: parent.width
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                }

                Rectangle {
                    width: parent.width
                    height: authorLbl.height
                    color: "transparent"

                    Label {
                        id: authorLbl
                        text: qsTr("by") + " " + author
                        anchors.left: parent.left
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    Label {
                        id: voteLbl
                        text: score + " " + (score > 1 ? qsTr("votes") : qsTr("vote"))
                        anchors.right: answerLbl.left
                        anchors.rightMargin: Theme.horizontalPageMargin
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    Label {
                        id: answerLbl
                        text: answer_count + " " + (answer_count > 1 ? qsTr("answers") : qsTr("answer"))
                        anchors.right: parent.right
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }

            onClicked: {
                py.setHandler('markdown.finished', function(html){
                    model.body = html
                    pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                })
                py.call('app.main.convert_markdown', [model.body])
            }
        }

        VerticalScrollDecorator {}
    }

    BusyIndicator {
        id: busy
        visible: !listModel.count
        running: true
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        py.setHandler('questions.finished', function(rs){
            for (var i=0; i<rs.length; i++){
                listModel.append(rs[i])
            }
        })

        py.call('app.main.get_questions')
    }
}
