import QtQuick 2.0
import Sailfish.Silica 1.0
import lbee.together.core 1.0
import "../components"

Page {
    property int currentPage: 1

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        anchors.fill: parent

        model: ListModel {
            id: listModel
        }

        PullDownMenu {
            id: pullDownMenu

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
                    currentPage = 1
                    refresh()
                }
            }
        }

        header: PageHeader {
            title: qsTr("Questions")
        }

        delegate: QuestionDelegate {
            onClicked: {
                py.setHandler('markdown.finished', function(html){
                    model.body = html
                    pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                })
                py.call('app.main.convert_markdown', [model.body])
            }
        }

        VerticalScrollDecorator {}

        PushUpMenu {
            id: pushUpMenu
            visible: false

            MenuItem {
                text: qsTr("Load more")
                onClicked: {
                    currentPage++
                    pushUpMenu.busy = true
                    refresh(true)
                }
            }
        }
    }

    BusyIndicator {
        id: loader
        visible: false
        running: true
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        py.setHandler('questions.finished', function(rs){
            pullDownMenu.busy = false
            pushUpMenu.busy = false
            loader.visible = false

            if (rs.questions){
                pushUpMenu.visible = true

                for (var i=0; i<rs.questions.length; i++){
                    listModel.append(rs.questions[i])
                }
            }
        })

        py.setHandler('questions.error', function(){
            loader.visible = false
            pullDownMenu.busy = false
            pushUpMenu.busy = false
        })

        refresh()
    }

    Connections {
        target: settings
        onOrderChanged: refresh()
    }

    function refresh(next){
        var order, dir;

        switch (settings.order){
        case Settings.Date: order = "age"; dir = "desc"; break;
        case Settings.Activity: order = "activity"; dir = "desc"; break;
        case Settings.Answers: order = "answers"; dir = "desc"; break;
        case Settings.Votes: order = "votes"; dir = "desc"; break;
        }

        if (!next){
            listModel.clear()
            loader.visible = true
        }

        pullDownMenu.busy = true
        pushUpMenu.busy = true

        py.call('app.main.get_questions', [{sort: order + '-' + dir, page: currentPage}])
    }
}
