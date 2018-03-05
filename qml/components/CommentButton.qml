import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    color: "transparent"
    height: content.height

    Row{
        id: content
        width: parent.width
        spacing: Theme.paddingMedium

        IconButton{
            icon.source: "image://theme/icon-s-message?" + (mouse.pressed ? Theme.highlightColor : Theme.primaryColor)
            height: parent.height
            width: Theme.iconSizeSmall
        }
        Label{
            text: "add a comment"
            color: mouse.pressed ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            width: parent.width
        }
    }

    MouseArea{
        id: mouse
        anchors.fill: parent
    }
}
