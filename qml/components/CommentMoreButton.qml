import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root

    property int padding: 0

    signal clicked()

    color: "transparent"
    height: content.height + (2 * padding)

    Row {
        id: content
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.paddingMedium

        IconButton {
            icon.source: "image://theme/icon-s-message?" + (mouse.pressed ? Theme.highlightColor : Theme.primaryColor)
            height: parent.height
            width: Theme.iconSizeSmall
        }

        Label {
            text: qsTr("see more comments")
            color: mouse.pressed ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            width: parent.width
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
