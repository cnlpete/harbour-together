import QtQuick 2.2
import Sailfish.Silica 1.0
import lbee.together.core 1.0

Page {
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        header: PageHeader {
            title: qsTr("Settings")
        }

        model: VisualItemModel {
            ComboBox {
                id: updateIntervalComboBox
                width: listView.width
                label: qsTr("Updates check interval")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("No update")
                        onClicked: settings.updateDelay = 0
                    }

                    MenuItem {
                        text: qsTr("5 minutes")
                        onClicked: settings.updateDelay = 1000*60*5
                    }

                    MenuItem {
                        text: qsTr("30 minutes")
                        onClicked: settings.updateDelay = 1000*60*30
                    }

                    MenuItem {
                        text: qsTr("1 hour")
                        onClicked: settings.updateDelay = 1000*60*60
                    }
                }
            }

            ComboBox {
                id: fontSizeComboBox
                width: listView.width
                label: qsTr('Font size')
                description: qsTr('Change text size in question view page')
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr('Normal')
                        onClicked: settings.fontSize = 1
                    }

                    MenuItem {
                        text: qsTr('Big')
                        onClicked: settings.fontSize = 2
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        Component.onCompleted: {
            switch (settings.updateDelay){
            case 0: updateIntervalComboBox.currentIndex = 0; break
            case 1000*60*5: updateIntervalComboBox.currentIndex = 1; break
            case 1000*60*30: updateIntervalComboBox.currentIndex = 2; break
            case 1000*60*60: updateIntervalComboBox.currentIndex = 3; break
            }

            switch (settings.fontSize){
            case 1: fontSizeComboBox.currentIndex = 0; break
            case 2: fontSizeComboBox.currentIndex = 1; break
            }
        }
    }
}
