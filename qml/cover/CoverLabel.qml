import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property alias count: updateCount.text
    property alias label: updateLabel.text

    width: parent.width
    height: updateCount.height

    Label {
        id: updateCount
        x: Theme.paddingLarge
        font.pixelSize: Theme.fontSizeHuge
    }

    Label {
        id: updateLabel
        x: Theme.paddingLarge
        font.pixelSize: Theme.fontSizeExtraSmall
        maximumLineCount: 2
        wrapMode: Text.Wrap
        fontSizeMode: Text.HorizontalFit
        lineHeight: 0.8
        height: implicitHeight/0.8
        verticalAlignment: Text.AlignVCenter
        anchors {
            right: parent.right
            left: updateCount.right
            leftMargin: Theme.paddingMedium
            baseline: updateCount.baseline
            baselineOffset: lineCount > 1 ? -implicitHeight/2 : -(height-implicitHeight)/2
        }
    }

    OpacityRampEffect {
        offset: 0.5
        sourceItem: updateLabel
        enabled: updateLabel.implicitWidth > Math.ceil(updateLabel.width)
    }
}
