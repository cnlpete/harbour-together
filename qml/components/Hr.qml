import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property int paddingTop: 0
    property int paddingBottom: 0

    color: "transparent"
    height: 1 + paddingTop + paddingBottom
    opacity: 0.8

    Rectangle{
        height: 1
        width: parent.width
        color: Theme.primaryColor
        anchors.topMargin: paddingTop
        anchors.bottomMargin: paddingBottom
        anchors.verticalCenter: parent.verticalCenter
    }
}
