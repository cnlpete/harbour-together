import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property variant dataModel: ({})
    property bool deleting: false

    signal deleted()

    height: col.height
    visible: dataModel.content.length

    Column {
        id: col
        width: parent.width
        spacing: Theme.paddingSmall

        Row {
            width: parent.width
            anchors.left: content.left
            spacing: Theme.paddingMedium

            Label {
                id: authorLbl
                text: "\uf007 %1".arg(dataModel.author)
                color: Theme.highlightColor
                font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/UserPage.qml"), {user: {username: dataModel.author, profile_url: dataModel.profile_url}})
                    }
                }
            }

            Label {
                id: datetimeLbl
                width: parent.width - authorLbl.width - Theme.paddingMedium
                horizontalAlignment: Text.AlignRight
                text: dataModel.date_ago
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.baseline: authorLbl.baseline
            }
        }

        Label {
            id: contentLbl
            text: dataModel.content
            textFormat: Text.StyledText
            color: Theme.secondaryColor
            linkColor: Theme.secondaryHighlightColor
            font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeExtraSmall : Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            onLinkActivated: handleLink(link)
        }

        Label {
            id: deleteBtn
            visible: dataModel.is_deletable
            text: qsTr(deleting ? 'deleting...' : 'delete')
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingMedium

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (deleting) return

                    remorseItem.execute(root, qsTr('Deleting...'), function(){
                        deleting = true
                        py.call('app.api.delete_comment', [dataModel.id], function(rs){
                            deleting = false
                            if (rs){
                                root.deleted()
                            }
                        })
                    })
                }
            }
        }
    }

    RemorseItem {
        id: remorseItem
    }
}
