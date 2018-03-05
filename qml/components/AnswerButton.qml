import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    color: "transparent"
    height: content.height

    Row{
        id: content
        width: parent.width

        IconButton{
            icon.source: "image://theme/icon-m-message?" + (mouse.pressed ? Theme.highlightColor : Theme.primaryColor)
            height: parent.height
            width: Theme.iconSizeMedium + 2 * Theme.paddingMedium
        }
        Label{
            text: "Login/Signup to Answer"
            color: mouse.pressed ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            width: parent.width
        }
    }

    MouseArea{
        id: mouse
        anchors.fill: parent
    }
}
