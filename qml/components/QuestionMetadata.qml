import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    property string iconValue
    property string textValue

    id: root
    height: iconElm.height
    spacing: Theme.paddingSmall

    Text {
        id: iconElm
        font.pixelSize: Theme.fontSizeExtraSmall
        font.family: iconFont.name
        text: iconValue
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.5
        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
    }

    Label {
        text: textValue
        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        wrapMode: Text.WordWrap
        font.pixelSize: Theme.fontSizeExtraSmall
        anchors.verticalCenter: parent.verticalCenter
    }
}
