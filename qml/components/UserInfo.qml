import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root

    property variant dataModel

    height: row.height
    color: "transparent"

    Row {
        id: row
        anchors.fill: parent
        height: avatar.height + 2 * Theme.paddingMedium
        spacing: Theme.paddingMedium

        Image {
            id: avatar
            source: dataModel ? dataModel.avatar_url : ""
            visible: !!dataModel && !!dataModel.avatar_url
            width: Theme.itemSizeSmall
            height: Theme.itemSizeSmall
            anchors.verticalCenter: parent.verticalCenter
        }

        Column{
            spacing: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter

            Label{
                id: author
                text: dataModel ? dataModel.username : ""
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Label{
                id: badges
                text: {
                    if (!dataModel) return ""

                    var str = []

                    str.push(dataModel.reputation)
                    if (dataModel.badge1){
                        str.push("<span style=\"color:gold\">●</span> " + dataModel.badge1)
                    }
                    if (dataModel.badge2){
                        str.push("<span style=\"color:silver\">●</span> " + dataModel.badge2)
                    }
                    if (dataModel.badge3){
                        str.push("<span style=\"color:saddlebrown \">●</span> " + dataModel.badge3)
                    }

                    return str.join(" ")
                }
                textFormat: Text.RichText
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }
}
