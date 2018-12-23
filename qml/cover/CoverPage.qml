import QtQuick 2.2
import Sailfish.Silica 1.0

CoverBackground {
    id: root

    property bool loading: false

    Rectangle {
        anchors.fill: parent
        opacity: 0.5
        color: 'black'
        visible: app.isLoggedIn

        Image {
            id: avatar
            source: app.avatarUrl
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
    }

    Column {
        spacing: Theme.paddingSmall
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.rightMargin: Theme.paddingMedium
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingMedium
        visible: app.isLoggedIn

        CoverLabel {
            id: karmaLabel
            label: "\uf005"
            value: app.reputation
        }

        CoverLabel {
            id: goldMedal
            label: "\uf5a2"
            labelColor: "gold"
            value: app.badge1
            visible: value > 0
        }

        CoverLabel {
            id: silverMedal
            label: "\uf5a2"
            labelColor: "silver"
            value: app.badge2
            visible: value > 0
        }

        CoverLabel {
            id: bronzeMedal
            label: "\uf5a2"
            labelColor: "saddlebrown"
            value: app.badge3
            visible: value > 0
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

    CoverPlaceholder {
        icon.source: "/usr/share/icons/hicolor/86x86/apps/harbour-together.png"
        text: "Together"
        visible: !app.isLoggedIn
    }

    CoverActionList {
        enabled: app.isLoggedIn

        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: checkUpdates()
        }
    }

    function checkUpdates(){
        if (loading) return
        loading = true

        py.call('app.api.check_user_update', [], function(rs){
            loading = false
            if (rs){
                if (rs.reputation) karmaLabel.value = rs.reputation
                if (rs.avatarUrl) avatar.source = rs.avatarUrl
                if (rs.badge1) goldMedal.value = rs.badge1
                if (rs.badge2) silverMedal.value = rs.badge2
                if (rs.badge3) bronzeMedal.value = rs.badge3
            }
        })
    }
}
