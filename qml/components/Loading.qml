import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root

    property bool loading: false
    property bool hasError: false
    property alias text: label.text

    color: "transparent"
    visible: loading || hasError

    Column {
        spacing: Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: busyIndicator.height + label.height
        width: parent.width

        BusyIndicator {
            id: busyIndicator
            visible: !hasError && loading
            running: true
            size: BusyIndicatorSize.Medium
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: label
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeMedium
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
