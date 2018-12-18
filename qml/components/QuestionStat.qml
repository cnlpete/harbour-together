import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    property alias label: labelElm.text
    property alias value: valueElm.text

    id: root
    height: labelElm.height

    Label {
        id: labelElm
        width: parent.width / 2
    }

    Label {
        id: valueElm
        width: parent.width / 2
        horizontalAlignment: Text.AlignRight
    }
}
