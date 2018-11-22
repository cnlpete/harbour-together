import QtQuick 2.2
import Sailfish.Silica 1.0

CoverBackground {
    id: root

    property int question_count: 0
    property bool loading: false

    Column {
        width: parent.width
        spacing: Theme.paddingLarge

        CoverLabel {
            id: unreadLabel
            count: "0"
            label: "new\nquestions"
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
        running: Qt.application.state === Qt.ApplicationInactive
        onRunningChanged: {
            if (Qt.application.state === Qt.ApplicationActive){
                unreadLabel.count = '0';
            }
        }
        onTriggered: checkUpdates()
    }

    function checkUpdates(){
        if (loading) return
        loading = true

        py.call('app.main.get_questions', [], function(data){
            if (data && data.count){
                loading = false
                if (!question_count){
                    question_count = data.count
                }else if (data.count > question_count){
                    unreadLabel.count = data.count - question_count
                    question_count = data.count
                }
            }
        })
    }
}
