import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: delegate
    height: titleLbl.height + authorLbl.height + Theme.horizontalPageMargin

    Column {
        anchors {
            fill: parent
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            topMargin: Theme.horizontalPageMargin / 2
            bottomMargin: Theme.horizontalPageMargin / 2
        }

        Label {
            id: titleLbl
            text: title
            width: parent.width
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
        }

        Rectangle {
            width: parent.width
            height: authorLbl.height
            color: "transparent"

            Label {
                id: authorLbl
                text: qsTr("by") + " " + author
                anchors.left: parent.left
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Row {
                id: voteLbl
                anchors.right: answerLbl.left
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingSmall

                Image {
                    source: "image://theme/icon-s-like"
                    anchors.verticalCenter: parent.verticalCenter
                    width: Theme.iconSizeSmall
                    height: Theme.iconSizeSmall
                    opacity: 0.4
                }

                Label {
                    text: score
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                id: answerLbl
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingSmall

                Image {
                    source: "image://theme/icon-s-chat"
                    anchors.verticalCenter: parent.verticalCenter
                    width: Theme.iconSizeSmall
                    height: Theme.iconSizeSmall
                    opacity: 0.4
                }

                Label {
                    text: answer_count
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
