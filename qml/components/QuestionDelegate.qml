import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

BackgroundItem {
    id: delegate
    height: column.height + 2 * Theme.horizontalPageMargin

    Column {
        id: column
        spacing: Theme.paddingSmall
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.verticalCenter: parent.verticalCenter

        Label {
            // Question title
            id: titleLbl
            text: Utils.processQuestionTitle(title)
            width: parent.width
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeMedium
        }

        Row {
            id: row
            width: parent.width
            //height: authorIcon.height
            spacing: Theme.paddingSmall

            QuestionMetadata {
                visible: typeof author !== "undefined"
                iconValue: "\uf007"
                textValue: typeof author !== "undefined" ? author : ""
            }

            Rectangle {
                // Separator
                visible: typeof author !== "undefined"
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                visible: typeof view_count_label !== "undefined"
                iconValue: "\uf06e"
                textValue: typeof view_count_label !== "undefined" ? view_count_label : ""
            }

            Rectangle {
                // Separator
                visible: typeof view_count_label !== "undefined"
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                visible: typeof score_label !== "undefined"
                iconValue: "\uf164"
                textValue: typeof score_label !== "undefined" ? score_label : ""
            }

            Rectangle {
                // Separator
                visible: typeof score_label !== "undefined"
                color: "transparent"
                width: Theme.paddingSmall
                height: 1
            }

            QuestionMetadata {
                visible: typeof answer_count_label !== "undefined"
                iconValue: "\uf086"
                textValue: typeof answer_count_label !== "undefined" ? answer_count_label : ""
            }
        }
    }
}
