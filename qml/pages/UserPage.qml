import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root

    property var user: ({id: '1856', username: 'Keeper-of-the-Keys'})
    property bool loading: true

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            visible: !loading
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                title: user.username
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin

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
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        BusyIndicator {
            id: busyIndicator
            running: true
            size: BusyIndicatorSize.Medium
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: loading
        }
    }

    Component.onCompleted: {
        py.setHandler('user.finished', function(rs){
            loading = false
            console.log(JSON.stringify(rs))
            avartar.source = rs.avartar_url
            created.text = rs.created
        })

        py.setHandler('user.error', function(msg){
            loading = false
            console.log(msg)
        })

        py.call('app.main.get_user', [user])
    }
}
