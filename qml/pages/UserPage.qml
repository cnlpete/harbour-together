import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

Page {
    id: root

    property var user: ({id: '1856', username: 'Keeper-of-the-Keys'})
    property bool loading: true
    property bool hasError: false

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu {
            MenuItem {
                text: qsTr("View in browser")
                onClicked: {
                    Utils.handleLink(user.info_url, true)
                }
            }
        }

        Column {
            id: content
            visible: !loading && !hasError
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                title: user.username || ""
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium

                Rectangle {
                    width: Theme.iconSizeExtraLarge
                    height: width

                    Image {
                        id: avartar
                        anchors.fill: parent
                    }
                }

                Column {
                    Label {
                        id: created

                        property string value: ''

                        text: qsTr('Member since') + ': ' + value
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        id: last_seen

                        property string value: ''

                        text: qsTr('Last seen') + ': ' + value
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        id: score

                        property string value: ''

                        text: qsTr('Karma') + ': ' + value
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }

            SectionHeader {
                id: question_section

                property int count: 0

                text: count + ' ' + qsTr('Questions')
            }

            ListView {
                id: questionsListView
                interactive: false
                width: parent.width
                height: count > 0 ? contentHeight : 0

                model: ListModel {
                    id: questionsModel
                }

                delegate: BackgroundItem {
                    id: delegate
                    width: questionsListView.width
                    height: questionTitle.height + 2 * Theme.paddingMedium

                    Label {
                        id: questionTitle
                        text: title
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.horizontalPageMargin
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingMedium
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Loading {
        id: busy
        loading: root.loading
        hasError: root.hasError
        text: qsTr("Loading user %1").arg(user.username)
        anchors.fill: parent
    }

    Component.onCompleted: {
        py.setHandler('user.finished', function(rs){
            //console.log(JSON.stringify(rs))
            loading = false

            avartar.source = rs.avartar_url
            created.value = rs.created
            last_seen.value = rs.last_seen
            score.value = rs.score
            question_section.count = rs.questions_count
            for (var i=0; i<rs.questions.length; i++){
                questionsModel.append(rs.questions[i])
            }
        })

        py.setHandler('user.error', function(){
            loading = false
            hasError = true
            busy.text = qsTr("Could not load data")
        })

        py.call('app.main.get_user', [user])
    }
}
