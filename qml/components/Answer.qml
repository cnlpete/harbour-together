import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/ultils.js" as Ultils

Rectangle {
    property variant dataModel
    property variant userModel
    property variant questionModel

    height: container.height
    color: "transparent"

    Column {
        id: container
        width: parent.width

        UserInfo {
            dataModel: userModel
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
        }

        Row {
            width: parent.width

            Column {
                id: leftCol
                width: Theme.horizontalPageMargin + Theme.itemSizeSmall + Theme.paddingMedium
                height: 1

                IconButton {
                    id: upBtn
                    icon.source: "image://theme/icon-m-up"
                    width: parent.width
                    visible: false
                }

                Label {
                    id: voteLbl
                    text: dataModel.vote_count_label
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    width: Theme.itemSizeSmall
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Label {
                    font.family: iconFont.name
                    text: "\uf164"
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    width: Theme.itemSizeSmall
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                IconButton {
                    id: downBtn
                    icon.source: "image://theme/icon-m-down"
                    width: parent.width
                    visible: false
                }
            }

            Column {
                id: rightCol
                width: parent.width - leftCol.width// - Theme.paddingMedium - Theme.horizontalPageMargin

                Label {
                    id: text
                    text: dataModel.content
                    //textFormat: Text.RichText
                    color: Theme.primaryColor
                    linkColor: Theme.highlightColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width
                    onLinkActivated: Ultils.handleLink(link)
                }
            }
        }

        Hr {
            width: parent.width
            paddingTop: Theme.paddingMedium
            paddingBottom: Theme.paddingMedium
        }

        Repeater {
            model: ListModel {
                id: commentModel
            }

            Rectangle {
                width: parent.width
                height: comment.height
                color: "transparent"

                Comment {
                    id: comment
                    dataModel: model
                    width: parent.width
                }
            }
        }

        CommentButton {
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
            anchors.right: parent.right
            padding: Theme.paddingMedium
            onClicked: {
                var url = questionModel.url + '#comments-for-answer-' + dataModel.id
                Ultils.handleLink(url, true)
            }
        }

        Hr {
            width: parent.width
            paddingTop: Theme.paddingMedium
            paddingBottom: Theme.paddingMedium
        }
    }

    Component.onCompleted: {
        if (dataModel){
            if (dataModel.comments){
                for (var i=0; i<dataModel.comments.count; i++){
                    commentModel.append(dataModel.comments.get(i))
                }
            }
            if (dataModel.user){
                userModel = dataModel.user
            }
        }
    }
}
