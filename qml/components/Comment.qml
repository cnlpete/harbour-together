import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/utils.js" as Utils

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
            textFormat: Text.StyledText
            color: Theme.secondaryColor
            linkColor: Theme.secondaryHighlightColor
            font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            onLinkActivated: Utils.handleLink(link)
        }

        Row {
            width: parent.width
            anchors.left: content.left
            spacing: Theme.paddingMedium

            Label {
                text: dataModel.author
                color: Theme.highlightColor
                font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/UserPage.qml"), {user: {username: dataModel.author, profile_url: dataModel.profile_url}})
                    }
                }
            }

            Label {
                text: dataModel.date_ago ? "(" + dataModel.date_ago + ")" : ""
                color: Theme.secondaryColor
                font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            }
        }
    }
}
