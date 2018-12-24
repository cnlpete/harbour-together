import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property int paddingTop: 0
    property int paddingBottom: 0
    property alias color: separator.color

    height: separator.height + paddingTop + paddingBottom

    Separator {
        id: separator
        color: Theme.secondaryColor
        width: parent.width
        horizontalAlignment: Qt.AlignCenter
        anchors.topMargin: paddingTop
        anchors.bottomMargin: paddingBottom
        anchors.verticalCenter: {
            if (paddingTop > 0 && paddingBottom === 0){
                return parent.bottom
            }else if (paddingTop === 0 && paddingBottom > 0){
                return parent.top
            }else{
                return parent.verticalCenter
            }
        }
    }
}
