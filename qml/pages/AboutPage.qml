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
                title: qsTr("About Together")
            }

            AboutLabel {
                text: "Version " + Qt.application.version
            }

            AboutLabel {
                text: "Copyright © 2018 Nguyen Long"
            }

            AboutLabel {
                text: "Unoffical native Together.Jolla.Com client for Sailfish OS"
            }

            AboutLabel {
                text: "This is an open source software which is distributed under the terms of the <a href=\"https://opensource.org/licenses/MIT\">MIT License</a>"
                onLinkActivated: Utils.handleLink(link)
            }

            AboutLabel {
                text: "By using this app you automatically agree to Together.Jolla.Com's "+
                      "<a href=\"https://together.jolla.com/jolla/terms_and_conditions/\">Terms of Service</a> and " +
                      "<a href=\"https://jolla.com/privacy-policy/\">Privacy Policy</a>"
                onLinkActivated: Utils.handleLink(link)
            }
        }
    }
}
