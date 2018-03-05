import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property variant dataModel

    height: col.height
    color: "transparent"
    visible: content.length

    Column{
        id: col
        width: parent.width

        Label{
            text: dataModel.content
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            width: parent.width - Theme.paddingLarge
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
        }

        Label{
            text: dataModel.author
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
        }

        Hr{
            width: parent.width
            opacity: 0.4
            paddingTop: Theme.paddingMedium
        }
    }
}
