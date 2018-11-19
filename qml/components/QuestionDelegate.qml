import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

BackgroundItem {
    id: delegate
    height: column.height + 2 * Theme.horizontalPageMargin

    Column {
        id: column
        height: titleLbl.height + row.height
        width: parent.width
        spacing: Theme.paddingSmall
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.top: parent.top
        anchors.topMargin: Theme.horizontalPageMargin

        Label {
            // Question title
            id: titleLbl
            text: title
            width: parent.width
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
        }

        Row {
            id: row
            width: parent.width
            //height: authorIcon.height
            spacing: Theme.paddingSmall

            QuestionMetadata {
                iconValue: "\uf007"
                textValue: author
            }

            Rectangle {
                // Separator
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                iconValue: "\uf06e"
                textValue: view_count_label
            }

            Rectangle {
                // Separator
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                iconValue: "\uf164"
                textValue: score_label
            }

            Rectangle {
                // Separator
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                iconValue: "\uf086"
                textValue: answer_count_label
            }

            Rectangle {
                // Separator
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                iconValue: "\uf017"
                textValue: added_at_label
            }
        }
    }
}
