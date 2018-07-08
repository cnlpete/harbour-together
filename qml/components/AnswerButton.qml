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

        IconButton {
            icon.source: "image://theme/icon-m-message?" + (mouse.pressed ? Theme.highlightColor : Theme.primaryColor)
            height: parent.height
            width: Theme.iconSizeMedium + 2 * Theme.paddingMedium
        }

        Label {
            text: "Login/Signup to Answer"
            color: mouse.pressed ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            width: parent.width
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
