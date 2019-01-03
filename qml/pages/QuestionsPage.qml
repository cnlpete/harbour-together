import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

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
    property bool hasMore: false

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

        section {
            property: 'section'

            delegate: SectionHeader {
                text: section
                height: Theme.itemSizeExtraSmall
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

        PushUpMenu {
            id: pushUpMenu
            visible: hasMore && listModel.count
            busy: loading

            MenuItem {
                text: qsTr(loading ? 'Loading...' : 'Load more')
                onClicked: {
                    if (loading) return

                    p += 1
                    refresh()
                }
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

    onStatusChanged: {
        if (status === PageStatus.Active){
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

    function refresh(){
        if (loading) return
        loading = true

        if (p == 1){
            listModel.clear()
        }

        py.call('app.api.get_questions', [{scope: scope, sort: order + '-' + direction, tags: tags, query: query, page: p}], function(rs){
            loading = false

            if (!rs){
                if (p > 1){
                    p -= 1
                }
                return
            }

            if (rs.questions && rs.questions.length){
                for (var i=0; i<rs.questions.length; i++){
                    var item = rs.questions[i]
                    item.section = Format.formatDate(new Date(item.last_activity * 1000), Formatter.TimepointSectionRelative)
                    listModel.append(item)
                }
            }

            if (rs.page < rs.pages){
                hasMore = true
            }else{
                hasMore = false
            }
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
}
