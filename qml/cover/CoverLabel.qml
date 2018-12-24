import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property alias label: labelElm.text
    property alias labelColor: labelElm.color
    property alias value: valueElm.text

    width: parent.width
    height: labelWrapper.height

    Item {
        id: labelWrapper
        width: Theme.iconSizeMedium - Theme.paddingLarge
        height: labelElm.height

        Label {
            id: labelElm
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Label {
        id: valueElm
        font.pixelSize: Theme.fontSizeLarge
        maximumLineCount: 1
        anchors {
            right: parent.right
            left: labelWrapper.right
            leftMargin: Theme.paddingMedium
        }
    }
}
