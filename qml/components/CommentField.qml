import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: root

    property alias text: commentTextArea.text

    signal submit()

    TextArea {
        id: commentTextArea
        placeholderText: qsTr('add a comment')
        label: text.trim().length < 10 ? qsTr('Enter at least %n more characters', '', 10 - text.trim().length) : ''
        _labelItem.font.pixelSize: Theme.fontSizeExtraSmall
        width: parent.width - commentSendBtn.width
        textWidth: width
        textMargin: 0
        font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
    }

    Label {
        id: commentSendBtn
        text: "\uf1d8"
        width: Theme.itemSizeSmall
        height: commentTextArea.height - commentTextArea._labelItem.height - Theme.paddingMedium
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        color: commentSendBtnMouse.pressed ? Theme.highlightColor : Theme.primaryColor
        opacity: commentTextArea.text ? 1 : 0.3

        MouseArea {
            id: commentSendBtnMouse
            anchors.fill: parent
            onClicked: root.submit()
        }
    }

    function reset(){
        commentTextArea.text = ''
    }
}
