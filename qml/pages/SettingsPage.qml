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
                id: updateIntervalCombo
                width: listView.width
                label: qsTr("Updates check interval")

                menu: ContextMenu {
                    MenuItem {
                        text: "No update"
                        onClicked: {
                            settings.updateDelay = 0
                        }
                    }

                    MenuItem {
                        text: qsTr("5 minutes")
                        onClicked: {
                            settings.updateDelay = 1000*60*5
                        }
                    }

                    MenuItem {
                        text: qsTr("30 minutes")
                        onClicked: {
                            settings.updateDelay = 1000*60*30
                        }
                    }

                    MenuItem {
                        text: qsTr("1 hour")
                        onClicked: {
                            settings.updateDelay = 1000*60*60
                        }
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        Component.onCompleted: {
            switch (settings.updateDelay){
            case 0: updateIntervalCombo.currentIndex = 0; break
            case 1000*60*5: updateIntervalCombo.currentIndex = 1; break
            case 1000*60*30: updateIntervalCombo.currentIndex = 2; break
            case 1000*60*60: updateIntervalCombo.currentIndex = 3; break
            }
        }
    }
}
