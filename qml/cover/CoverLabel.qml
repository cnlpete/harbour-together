import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property alias label: labelElm.text
    property alias labelColor: labelElm.color
    property alias value: valueElm.text

    width: parent.width
    height: labelElm.height

    Label {
        id: labelElm
        width: Theme.iconSizeSmall
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: valueElm
        font.pixelSize: Theme.fontSizeMedium
        anchors {
            right: parent.right
            left: labelElm.right
            leftMargin: Theme.paddingMedium
        }
    }
}
