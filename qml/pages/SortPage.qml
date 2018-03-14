import QtQuick 2.0
import Sailfish.Silica 1.0
import lbee.together.core 1.0

Page {
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Sort by")
        }

        model: ListModel {
            ListElement {
                title: qsTr("Date")
                description: qsTr("See the newest questions")
                scope: "all"
                order: "age"
                dir: "desc"
            }

            ListElement {
                title: qsTr("Activity")
                description: qsTr("See the most recently updated questions")
                scope: "all"
                order: "activity"
                dir: "desc"
            }

            ListElement {
                title: qsTr("Answers")
                description: qsTr("See the most answered questions")
                scope: "all"
                order: "answers"
                dir: "desc"
            }

            ListElement {
                title: qsTr("Votes")
                description: qsTr("See least voted questions")
                scope: "all"
                order: "votes"
                dir: "desc"
            }
        }

        delegate: BackgroundItem {
            id: delegate
            height: titleLbl.height + descriptionLbl.height + Theme.horizontalPageMargin
            highlighted: listView.currentIndex == index

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

                Label {
                    id: descriptionLbl
                    text: description
                    width: parent.width
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            onClicked: {
                listView.currentIndex = index

                switch (model.order){
                case "age":
                    settings.order = Settings.Date;
                    break;
                case "activity":
                    settings.order = Settings.Activity;
                    break;
                case "answers":
                    settings.order = Settings.Answers;
                    break;
                case "votes":
                    settings.order = Settings.Votes;
                    break;
                }

                pageStack.pop()
            }
        }

        VerticalScrollDecorator {}

        Component.onCompleted: {
            switch (settings.order){
            case Settings.Date: listView.currentIndex = 0; break;
            case Settings.Activity: listView.currentIndex = 1; break;
            case Settings.Answers: listView.currentIndex = 2; break;
            case Settings.Votes: listView.currentIndex = 3; break;
            }
        }
    }
}
