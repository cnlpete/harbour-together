import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

Page {
    id: root

    property int p: 1
    property string scope: "all"
    property string order: "activity"
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
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Login")
                onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
                visible: !app.isLoggedIn
            }

            MenuItem {
                text: settings.username
                onClicked: pageStack.push(Qt.resolvedUrl("UserPage.qml"), {user: {username: settings.username, profile_url: settings.profileUrl}})
                visible: app.isLoggedIn
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
                EnterKey.iconSource: "image://theme/icon-m-search"
                EnterKey.onClicked: {
                    searchField.focus = false
                    query = searchField.text
                    p = 1
                    refresh()
                }
                onTextChanged: query = searchField.text
            }
        }

        delegate: QuestionDelegate {
            onClicked: {
                py.call('app.api.markdown', [model.body], function(html){
                    model.body = html
                    pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                })
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
        onSessionIdChanged: {
            if (!settings.sessionId && root.scope === 'followed'){
                root.scope = 'all'
            }
        }
    }

    function refresh(){
        if (loading) return

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

        py.call('app.api.get_questions', [{scope: scope, sort: order + '-' + direction, tags: tags, query: query, page: p}], function(rs){
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

            var filtersPage = pageStack.pushAttached(Qt.resolvedUrl("FiltersPage.qml"), {scope: scope, order: order, direction: direction, tags: tags})
            filtersPage.close.connect(function(){
                var reload = false

                if (scope !== filtersPage.scope){
                    scope = filtersPage.scope
                    reload = true
                }
                if (order !== filtersPage.order){
                    order = filtersPage.order
                    reload = true
                }
                if (direction !== filtersPage.direction){
                    direction = filtersPage.direction
                    reload = true
                }
                if (tags !== filtersPage.tags){
                    tags = filtersPage.tags
                    reload = true
                }

                if (reload){
                    p = 1
                    refresh()
                }
            })
        })
    }
}
