import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: root

    property alias text: commentTextArea.text
    property alias topMargin: commentTextArea.textTopMargin
    property bool loading: false
    property int minLength: 10

    signal submit()

    TextArea {
        id: commentTextArea
        placeholderText: qsTr('add a comment')
        label: text.trim().length < minLength ? qsTr('Enter at least %n more characters', '', minLength - text.trim().length) : ''
        _labelItem.font.pixelSize: Theme.fontSizeExtraSmall
        width: parent.width - commentSendBtn.width
        textWidth: width
        textMargin: 0
        font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
    }

    Label {
        id: commentSendBtn
        text: loading ? "" : "\uf1d8"
        width: Theme.itemSizeSmall
        height: commentTextArea.height - commentTextArea._labelItem.height - Theme.paddingMedium
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        color: commentSendBtnMouse.pressed ? Theme.highlightColor : Theme.primaryColor
        opacity: commentTextArea.text.trim().length >= minLength ? 1 : 0.3

        BusyIndicator {
            id: busyIndicator
            size: BusyIndicatorSize.ExtraSmall
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            running: true
            visible: loading
        }

        MouseArea {
            id: commentSendBtnMouse
            anchors.fill: parent
            onClicked: loading ? {} : root.submit()
        }
    }

    function reset(){
        commentTextArea.text = ''
        loading = false
    }

    function focus(){
        commentTextArea.forceActiveFocus()
    }
}
