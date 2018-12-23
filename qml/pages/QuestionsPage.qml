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
    property bool compactView: false

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        anchors.fill: parent

        model: ListModel {
            id: listModel
        }

        PullDownMenu {
            id: pullDownMenu
            busy: loading

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                visible: !compactView
            }

            MenuItem {
                text: qsTr("Login")
                onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
                visible: !app.isLoggedIn && !compactView
            }

            MenuItem {
                text: app.username
                onClicked: pageStack.push(Qt.resolvedUrl("UserPage.qml"), {user: {username: app.username, profile_url: app.profileUrl}})
                visible: app.isLoggedIn && !compactView
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
            title: qsTr('Questions')
            description: getFiltersDisplay()
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
    }

    BusyIndicator {
        id: loader
        visible: loading && p === 1
        running: true
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: listPlaceholder
        text: qsTr('No question')
        visible: !loader.visible && !listView.count
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Theme.fontSizeHuge
        color: Theme.secondaryColor
        opacity: 0.5
    }

    Component.onCompleted: {
        py.setHandler('questions.error', function(){
            loader.visible = false
            pullDownMenu.busy = false
            loading = false
        })

        refresh()
    }

    function refresh(){
        if (loading) return
        loading = true

        if (p == 1){
            listModel.clear()
        }

        py.call('app.api.get_questions', [{scope: scope, sort: order + '-' + direction, tags: tags, query: query, page: p}], function(rs){
            if (rs.questions && rs.questions.length){
                for (var i=0; i<rs.questions.length; i++){
                    listModel.append(rs.questions[i])
                }
            }
            loading = false
            attachFiltersPage()
        })
    }

    function getFiltersDisplay(){
        return qsTr("\uf07b %1   \uf15d %2-%3%4%5")
        .arg(scope)
        .arg(order)
        .arg(direction)
        .arg(query ? '   \uf002 '+query : '')
        .arg(tags ? '   \uf02b '+tags : '')
    }

    function attachFiltersPage(){
        var filtersPage = pageStack.pushAttached(Qt.resolvedUrl("FiltersPage.qml"), {scope: scope, order: order, direction: direction, tags: tags, query: query})
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
            if (query !== filtersPage.query){
                query = filtersPage.query
                reload = true
            }

            if (reload){
                p = 1
                refresh()
            }
        })
    }
}
