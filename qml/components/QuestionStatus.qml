import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root

    property var model: ({})

    visible: !!model.reason
    spacing: Theme.paddingMedium

    Hr {
        width: parent.width
        visible: !!model.reason
    }

    Label {
        text: qsTr('The question has been closed for the following reason: %1').arg(model.reason || '')
        width: parent.width
        font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
        color: Theme.secondaryColor
        wrapMode: Text.WordWrap
    }

    Row {
        width: parent.width

        Label {
            text: '\uf007 %1'.arg(model.author || '')
            width: parent.width / 2
            font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            color: Theme.secondaryHighlightColor

            MouseArea {
                anchors.fill: parent
                onClicked: pageStack.push(Qt.resolvedUrl('../pages/UserPage.qml'), {user: {username: model.author, profile_url: model.profile_url}})
            }
        }

        Label {
            text: model.date_ago || ''
            width: parent.width / 2
            horizontalAlignment: Text.AlignRight
            font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            color: Theme.secondaryColor
        }
    }

    Item {
        width: parent.width
        height: 1
    }
}
