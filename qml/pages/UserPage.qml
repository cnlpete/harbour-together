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
                    id: avartarElm
                    width: Theme.iconSizeExtraLarge
                    height: width

                    Image {
                        id: avartar
                        anchors.fill: parent
                    }
                }

                Column {
                    width: parent.width - avartarElm.width

                    QuestionStat {
                        label: qsTr('Member since')
                        value: user.created
                        width: parent.width
                    }

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

                delegate: QuestionDelegate {
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
        text: qsTr("\uf007 %1").arg(user.username)
        anchors.fill: parent
    }

    Component.onCompleted: {
        py.setHandler('user.error', function(){
            loading = false
            hasError = true
            busy.text = qsTr("Could not load data")
        })

        py.call('app.main.get_user', [user], function(rs){
            loading = false

            avartar.source = rs.avartar_url
            created.value = rs.created
            user.created = rs.created
            last_seen.value = rs.last_seen_label
            score.value = rs.score
            question_section.count = rs.questions_count
            for (var i=0; i<rs.questions.length; i++){
                questionsModel.append(rs.questions[i])
            }
        })
    }
}
