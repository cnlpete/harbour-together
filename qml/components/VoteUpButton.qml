import QtQuick 2.0
import Sailfish.Silica 1.0

Button {
    id: root

    property bool loading: false

    Image {
        source: "image://theme/icon-s-like"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: !loading
    }

    BusyIndicator {
        visible: loading
        running: loading
        size: BusyIndicatorSize.Small
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
