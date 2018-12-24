import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root

    property variant dataModel: ({})

    height: row.height
    color: "transparent"

    Row {
        id: row
        anchors.fill: parent
        height: avatar.height + 2 * Theme.paddingMedium
        spacing: Theme.paddingMedium

        Rectangle {
            id: avatar
            width: Theme.itemSizeSmall
            height: Theme.itemSizeSmall
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"

            Image {
                id: avatarImg
                source: dataModel && dataModel.avatar_url ? dataModel.avatar_url : ""
                anchors.fill: parent
            }

            Rectangle {
                id: avatarPlaceholder
                anchors.fill: parent
                color: "black"
                opacity: 0.4
                visible: !avatarImg.visible
            }

            MouseArea {
                visible: dataModel.profile_url
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("../pages/UserPage.qml"), {user: {username: dataModel.username, profile_url: dataModel.profile_url}})
                }
            }
        }

        Row {
            width: parent.width - avatar.width - parent.spacing

            Column {
                id: leftCol
                spacing: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    id: authorLbl
                    text: {
                        if (!dataModel) return ""
                        if (dataModel.is_wiki) return qsTr("This post is a wiki")
                        else if (dataModel.username) return dataModel.username
                        else return ""
                    }
                    color: Theme.primaryColor
                    font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeSmall : Theme.fontSizeMedium
                }

                Label{
                    id: badgesLbl
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
                    font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
                }
            }

            Column {
                id: rightCol
                spacing: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - leftCol.width

                Label {
                    id: isAuthorLbl
                    text: {
                        if (!dataModel) return ""
                        if (dataModel.asked) return qsTr("asked")
                        else if (dataModel.answered) return qsTr("answered")
                        else if (dataModel.updated) return qsTr("updated")
                        else return ""
                    }
                    color: Theme.secondaryColor
                    font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeSmall : Theme.fontSizeMedium
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                }

                Label {
                    id: dateLbl
                    text: dataModel && dataModel.date_ago ? dataModel.date_ago : ""
                    color: Theme.secondaryColor
                    font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
