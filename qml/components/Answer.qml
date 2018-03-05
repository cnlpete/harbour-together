import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    property variant dataModel

    height: container.height + Theme.paddingLarge
    color: "transparent"

    Row{
        id: container
        width: parent.width
        spacing: Theme.paddingMedium

        Column{
            width: Theme.iconSizeMedium
            Image {
                id: avatarImg
                source: dataModel.avatar_url
                width: parent.width
                height: parent.width
                visible: dataModel.avatar_url.length
            }
            IconButton{
                id: upBtn
                icon.source: "image://theme/icon-m-up"
                width: parent.width
                visible: false
            }
            Label{
                id: voteLbl
                text: "38"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: false
            }
            IconButton{
                id: downBtn
                icon.source: "image://theme/icon-m-down"
                width: parent.width
                visible: false
            }
        }

        Column{
            width: parent.width - Theme.iconSizeMedium - Theme.paddingMedium

            Label{
                id: author
                text: "Damien Caliste"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                visible: false
            }
            Label{
                id: text
                text: dataModel.content
                textFormat: Text.RichText
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
            }

            Hr{
                width: parent.width
                paddingTop: Theme.paddingMedium
                paddingBottom: Theme.paddingMedium
            }

            Repeater{
                model: ListModel{
                    id: commentModel
                }

                Rectangle{
                    width: parent.width
                    height: comment.height
                    color: "transparent"

                    Comment{
                        id: comment
                        dataModel: model
                        width: parent.width
                    }
                }
            }

            CommentButton{
                width: parent.width
            }
        }
    }

    Hr{
        anchors.top: container.bottom
        anchors.topMargin: Theme.paddingMedium
        width: parent.width
    }

    Component.onCompleted: {
        if (dataModel && dataModel.comments){
            for (var i=0; i<dataModel.comments.count; i++){
                commentModel.append(dataModel.comments.get(i))
            }
        }
    }
}
