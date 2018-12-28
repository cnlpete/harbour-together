import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property alias text: tagLbl.text

    height: tagLbl.height + Theme.paddingSmall
    width: tagLbl.width + 2 * Theme.paddingMedium
    color: tagMouse.pressed ? Theme.highlightBackgroundColor : "transparent"
    border.width: 1
    border.color: Theme.highlightColor

    Label {
        id: tagLbl
        font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeSmall : Theme.fontSizeMedium
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: tagMouse.pressed ? Theme.primaryColor : Theme.highlightColor

        MouseArea {
            id: tagMouse
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../pages/QuestionsPage.qml"), {tags: tagLbl.text, compactView: true})
            }
        }
    }
}
