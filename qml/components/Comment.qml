import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/ultils.js" as Ultils

Rectangle {
    property variant dataModel

    height: col.height
    color: "transparent"
    visible: dataModel.content.length

    Column {
        id: col
        width: parent.width

        Label {
            id: content
            text: dataModel.content
            color: Theme.secondaryColor
            linkColor: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingMedium
            onLinkActivated: Ultils.handleLink(link)
        }

        Label {
            text: dataModel.author
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            anchors.left: content.left
        }

        Hr {
            width: parent.width
            opacity: 0.4
            paddingTop: Theme.paddingMedium
            paddingBottom: Theme.paddingMedium
            anchors.left: content.left
        }
    }
}
