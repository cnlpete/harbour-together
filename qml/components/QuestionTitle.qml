import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    property alias text: titleLbl.text
    property int paddingTop: 0
    property int paddingBottom: 0

    Item {
        width: parent.width
        height: paddingTop
    }

    Label {
        id: titleLbl
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignRight
        width: parent.width
    }

    Item {
        width: parent.width
        height: paddingBottom
    }
}
