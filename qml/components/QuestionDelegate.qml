import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: delegate
    height: titleLbl.height + authorLbl.height + 2 * Theme.horizontalPageMargin

    Column {
        anchors {
            fill: parent
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            topMargin: Theme.horizontalPageMargin
            bottomMargin: Theme.horizontalPageMargin
        }

        Label {
            // Question title
            id: titleLbl
            text: title
            width: parent.width
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
        }

        Rectangle {
            // Question metadata
            width: parent.width
            height: authorLbl.height
            color: "transparent"

            Label {
                // Author
                id: authorLbl
                text: qsTr("by") + " " + author
                anchors.left: parent.left
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingSmall

                Text {
                    // Vote icon
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.family: iconFont.name
                    text: "\uf164"
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.5
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }

                Label {
                    // Vote count
                    text: score_label
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    // Separator
                    color: "transparent"
                    width: Theme.paddingSmall
                    height: 1
                }

                Text {
                    // Answer icon
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.family: iconFont.name
                    text: "\uf086"
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.5
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }

                Label {
                    // Answer count
                    text: answer_count_label
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    // Separator
                    color: "transparent"
                    width: Theme.paddingSmall
                    height: 1
                }

                Text {
                    // View icon
                    font.pixelSize: Theme.fontSizeExtraSmall
                    font.family: iconFont.name
                    text: "\uf06e"
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.5
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }

                Label {
                    // View count
                    text: view_count_label
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
