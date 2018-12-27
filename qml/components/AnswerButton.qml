import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: root

    property int padding: Theme.paddingLarge

    height: content.height + (2 * padding)

    Row {
        id: content
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        IconButton {
            icon.source: "image://theme/icon-m-message"
            height: parent.height
            width: Theme.iconSizeMedium + 2 * Theme.paddingMedium
        }

        Label {
            text: qsTr("Login/Signup to answer")
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            width: parent.width
        }
    }
}
