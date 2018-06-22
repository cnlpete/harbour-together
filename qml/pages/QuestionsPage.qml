import QtQuick 2.0
import Sailfish.Silica 1.0
import lbee.together.core 1.0
import "../components"

Page {
    id: root

    property int p: 1
    property string scope: "all"
    property string order: getSetting('order')
    property string direction: "desc"
    property string query: ""
    property string tags: ""
    property bool loading: false

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
                text: loading ? qsTr("Refreshing...") : qsTr("Refresh")
                onClicked: {
                    if (!loading){
                        p = 1
                        refresh()
                    }
                }
            }
        }

        header: PageHeader {
            property alias searchField: searchField

            SearchField {
                id: searchField
                width: parent.width
                placeholderText: qsTr("Search, ask or submit idea")

                EnterKey.enabled: searchField.text.length > 0
                EnterKey.onClicked: {
                    searchField.focus = false
                    query = searchField.text
                    p = 1
                    refresh()
                }

                onTextChanged: {
                    if (!searchField.text && query){
                        searchField.focus = false
                        query = ""
                        p = 1
                        refresh()
                    }
                }
            }
        }

        delegate: QuestionDelegate {
            onClicked: {
                py.setHandler('markdown.finished', function(html){
                    model.body = html
                    pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                })
                py.call('app.main.markdown', [model.body])
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
                        p++
                        pushUpMenu.busy = true
                        refresh()
                    }
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
            loading = false

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
            loading = false
        })

        refresh()
    }

    Connections {
        target: settings
        onOrderChanged: {
            order = getSetting('order')
            p = 1
            refresh()
        }
    }

    function getSetting(name){
        var value

        switch (name){
        case 'order':
            switch (settings.order){
            case Settings.Date: value = "age"; break;
            case Settings.Answers: value = "answers"; break;
            case Settings.Votes: value = "votes"; break;
            case Settings.Activity:
            default: value = "activity";
            }
        }

        return value
    }

    function refresh(){
        loading = true

        if (p == 1){
            listModel.clear()
            loader.visible = true
        }

        pullDownMenu.busy = true
        if (p > 1){
            pushUpMenu.busy = true
        }else{
            pushUpMenu.visible = false
        }

        py.call('app.main.get_questions', [{
                                               scope: scope,
                                               sort: order + '-' + direction,
                                               tags: tags,
                                               query: query,
                                               page: p
                                           }])
    }
}
