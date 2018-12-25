import QtQuick 2.0
import Sailfish.Silica 1.0

Button {
    id: root

    property bool loading: false
    property bool vote: false

    Image {
        id: voteDownIcon
        source: "image://theme/icon-s-like?" + (vote ? Theme.highlightColor : Theme.primaryColor)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: !loading
        mirror: true
        transform: Rotation {
            origin.x: voteDownIcon.width / 2
            origin.y: voteDownIcon.height / 2
            angle: 180
        }
    }

    BusyIndicator {
        visible: loading
        running: loading
        size: BusyIndicatorSize.Small
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}
