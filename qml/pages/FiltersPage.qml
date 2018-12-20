import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string scope: "all"
    property string order: "activity"
    property string direction: "desc"
    property string tags: ""
    property string query: ""

    signal close()

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Filters")
        }

        model: VisualItemModel {
            TextField {
                id: queryFld
                label: qsTr("Search, ask or submit idea")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                onTextChanged: query = text
            }

            TextField {
                id: tagsFld
                label: qsTr("Tags (comma-separated)")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                onTextChanged: tags = text
            }

            ComboBox {
                id: scopeFld
                width: listView.width
                label: qsTr("Scope")
                description: {
                    switch (currentIndex){
                    case 0: return qsTr("See all questions")
                    case 1: return qsTr("See unanswered questions")
                    case 2: return qsTr("See your followed questions")
                    default: return ""
                    }
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("all")
                        onClicked: {
                            scope = 'all'
                        }
                    }

                    MenuItem {
                        text: qsTr("unanswered")
                        onClicked: {
                            scope = 'unanswered'
                        }
                    }

                    MenuItem {
                        text: qsTr("followed")
                        onClicked: {
                            scope = 'followed'
                        }
                        visible: app.isLoggedIn
                    }
                }
            }

            ComboBox {
                id: sortBy
                width: listView.width
                label: qsTr("Sort by")
                description: {
                    switch (currentIndex){
                    case 0: return qsTr("See the newest questions")
                    case 1: return qsTr("See the least recently updated questions")
                    case 2: return qsTr("See the most answered questions")
                    case 3: return qsTr("See most voted questions")
                    default: return ""
                    }
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("date")
                        onClicked: {
                            order = 'age'
                        }
                    }

                    MenuItem {
                        text: qsTr("activity")
                        onClicked: {
                            order = 'activity'
                        }
                    }

                    MenuItem {
                        text: qsTr("answers")
                        onClicked: {
                            order = 'answers'
                        }
                    }

                    MenuItem {
                        text: qsTr("votes")
                        onClicked: {
                            order = 'votes'
                        }
                    }
                }
            }

            ComboBox {
                id: sortDir
                width: listView.width
                label: qsTr("Sort direction")
                description: {
                    switch (currentIndex){
                    case 0: return qsTr("Ascending")
                    case 1: return qsTr("Descending")
                    default: return ""
                    }
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("asc")
                        onClicked: {
                            direction = 'asc'
                        }
                    }

                    MenuItem {
                        text: qsTr("desc")
                        onClicked: {
                            direction = 'desc'
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: settings
        onSessionIdChanged: {
            if (!settings.sessionId && page.scope === 'followed'){
                page.scope = 'all'
                update()
            }
        }
    }

    Component.onCompleted: {
        update()
    }

    onStatusChanged: {
        if (status === PageStatus.Inactive){
            page.close()
        }
    }

    function update(){
        switch (scope){
        case 'all': scopeFld.currentIndex = 0; break
        case 'unanswered': scopeFld.currentIndex = 1; break
        case 'followed': scopeFld.currentIndex = 2; break
        }

        switch (order){
        case 'date': sortBy.currentIndex = 0; break
        case 'activity': sortBy.currentIndex = 1; break
        case 'answers': sortBy.currentIndex = 2; break
        case 'votes': sortBy.currentIndex = 3; break
        }

        switch (direction){
        case 'asc': sortDir.currentIndex = 0; break
        case 'desc': sortDir.currentIndex = 1; break
        }

        tagsFld.text = tags
        queryFld.text = query
    }
}
