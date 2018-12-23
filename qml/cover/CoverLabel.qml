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
        font.pixelSize: Theme.fontSizeLarge
    }

    Label {
        id: valueElm
        font.pixelSize: Theme.fontSizeLarge
        anchors {
            right: parent.right
            left: labelElm.right
            leftMargin: Theme.paddingMedium
        }
    }
}
