import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: root

    Column {
        width: parent.width
        spacing: Theme.paddingLarge

        CoverLabel {
            id: unreadLabel

            count: "4"
            label: "updated\nquestions"
        }

        Label {
            id: statusLabel

            x: Theme.paddingLarge
            text: "Up to date"
            fontSizeMode: Text.VerticalFit
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: Text.Wrap
            width: parent.width - Theme.paddingLarge
            color: Theme.highlightColor
            elide: Text.ElideNone
            maximumLineCount: 3

            Behavior on opacity { FadeAnimation { duration: 500 } }

            Timer {
                property bool keepVisible

                repeat: true
                interval: 500
                running: app.loading && root.status === Cover.Active
                onRunningChanged: if (!running) statusLabel.opacity = 1.0
                onTriggered: {
                    if (keepVisible) {
                        keepVisible = false
                    } else {
                        keepVisible = statusLabel.opacity < 0.5
                        statusLabel.opacity = (statusLabel.opacity > 0.5 ? 0.0 : 1.0)
                    }
                }
            }
        }

        OpacityRampEffect {
            offset: 0.5
            sourceItem: statusLabel
            enabled: statusLabel.implicitWidth > statusLabel.width - Theme.paddingLarge
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: {
                app.refresh()
            }
        }
    }
}
