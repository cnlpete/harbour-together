import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"
import "../js/utils.js" as Utils

Page {
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingMedium

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("About")
            }

            Image {
                source: "/usr/share/icons/hicolor/128x128/apps/harbour-voyager.png"
                width: Theme.iconSizeExtraLarge
                height: width
                fillMode: Image.Stretch
                anchors.horizontalCenter: parent.horizontalCenter
            }

            AboutLabel {
                text: "Voyager"
                font.pixelSize: Theme.fontSizeLarge
            }

            AboutLabel {
                text: "Version " + Qt.application.version
            }

            AboutLabel {
                text: "Copyright © 2018 Nguyen Long"
            }

            AboutLabel {
                text: "Unoffical native <a href=\"https://together.jolla.com/\">Together.Jolla.Com</a> client for Sailfish OS"
            }

            AboutLabel {
                text: "This is an open source software which is distributed under the terms of the <a href=\"https://opensource.org/licenses/MIT\">MIT License</a>"
            }

            AboutLabel {
                text: "By using this app you automatically agree to Together.Jolla.Com's "+
                      "<a href=\"https://together.jolla.com/jolla/terms_and_conditions/\">Terms of Service</a> and " +
                      "<a href=\"https://jolla.com/privacy-policy/\">Privacy Policy</a>"
            }

            AboutLabel {
                text: "App icon by <a href=\"https://www.iconfinder.com/bendavis\">Creaticca Ltd</a>"
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            Button {
                text: 'Donate'
                onClicked: Utils.handleLink('https://www.paypal.me/nvlong')
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
