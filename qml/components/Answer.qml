import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/utils.js" as Utils

Rectangle {
    property variant dataModel
    property variant questionModel

    height: container.height
    color: "transparent"

    Column {
        id: container
        width: parent.width

        Repeater {
            model: ListModel {
                id: usersModel
            }

            Rectangle {
                width: parent.width
                height: userInfo.height + Theme.horizontalPageMargin
                color: "transparent"

                UserInfo {
                    id: userInfo
                    dataModel: model
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                    }
                }

                Hr {
                    width: parent.width
                    anchors.top: userInfo.bottom
                    paddingTop: Theme.horizontalPageMargin
                }
            }
        }

        Row {
            width: parent.width

            Column {
                id: leftCol
                width: Theme.horizontalPageMargin + Theme.itemSizeSmall + Theme.paddingMedium
                height: 1

                Label {
                    id: voteLbl
                    text: "\uf164 " + dataModel.vote_count_label
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    width: Theme.itemSizeSmall
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
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
                    onLinkActivated: Utils.handleLink(link)
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

        CommentMoreButton {
            visible: false
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
            anchors.right: parent.right
            padding: Theme.paddingMedium
            onClicked: {
                console.log("more")
            }
        }

        CommentButton {
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall
            anchors.right: parent.right
            padding: Theme.paddingMedium
            onClicked: {
                var url = questionModel.url + '#comments-for-answer-' + dataModel.id
                Utils.handleLink(url, true)
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
            if (dataModel.users){
                for (var i=0; i<dataModel.users.count; i++){
                    usersModel.append(dataModel.users.get(i))
                }
            }
        }
    }
}
