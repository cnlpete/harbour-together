import QtQuick 2.2
import Sailfish.Silica 1.0

CoverBackground {
    id: root

    property int question_count: 0
    property var question_activity: ({})
    property bool loading: false

    Column {
        width: parent.width
        spacing: Theme.paddingSmall

        CoverLabel {
            id: unreadLabel
            count: "0"
            label: "new\nquestions"
        }

        CoverLabel {
            id: updatedLabel
            count: "0"
            label: "updated\nquestions"
            visible: false
        }

        Label {
            id: statusLabel
            text: loading ? qsTr("Updating...") : qsTr("Up-to-date")
            x: Theme.paddingLarge
            fontSizeMode: Text.VerticalFit
            font.pixelSize: Theme.fontSizeLarge
            width: parent.width - Theme.paddingLarge
            color: Theme.highlightColor
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: checkUpdates()
        }
    }

    Timer {
        repeat: true
        interval: settings.updateDelay
        running: false//Qt.application.state === Qt.ApplicationInactive
        onRunningChanged: {
            if (Qt.application.state === Qt.ApplicationActive){
                unreadLabel.count = '0'
                updatedLabel.count = '0'
                question_count = 0
                question_activity = {}
            }else{
                checkUpdates()
            }
        }
        onTriggered: checkUpdates()
    }

    function checkUpdates(){
        if (loading) return
        loading = true

        py.call('app.main.get_questions', [], function(data){
            loading = false
            if (data && data.count){
                if (!question_count){
                    question_count = data.count
                }else if (data.count > question_count){
                    unreadLabel.count = data.count - question_count
                }

                if (data.questions){
                    var updated = 0
                    for (var i=0; i<data.questions.length; i++){
                        var q = data.questions[i]
                        if (typeof question_activity[q.id] === "undefined"){
                            question_activity[q.id] = q.last_activity
                        }else if (question_activity[q.id] !== q.last_activity){
                            updated++
                        }
                    }
                    updatedLabel.count = updated

                    if (!app.mainPage.viewChanged()){
                        app.mainPage.replaceItems(data.questions)
                    }
                }
            }
        })
    }
}
