import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/utils.js" as Utils

Item {
    property variant dataModel
    property variant questionModel

    height: container.height

    Column {
        id: container
        width: parent.width

        Repeater {
            model: ListModel {
                id: usersModel
            }

            Rectangle {
                width: parent.width
                height: userInfo.height + userInfoHr.height
                color: "transparent"

                UserInfo {
                    id: userInfo
                    dataModel: model
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.paddingMedium
                    }
                }

                Hr {
                    id: userInfoHr
                    width: parent.width
                    anchors.top: userInfo.bottom
                    visible: index < usersModel.count - 1
                }
            }
        }

        Hr {
            width: parent.width
            paddingBottom: Theme.paddingMedium
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.right: parent.right
            spacing: Theme.paddingMedium

            Column {
                id: leftCol
                width: Theme.itemSizeSmall

                VoteUpButton {
                    id: voteUpBtn
                    width: Theme.iconSizeMedium
                    anchors.horizontalCenter: parent.horizontalCenter
                    voted: votes[dataModel.id] === 1
                    onClicked: {
                        if (loading) return
                        loading = true

                        py.call('app.api.do_vote', [dataModel.id, 5], function(rs){
                            loading = false

                            if (rs && rs.success === 1){
                                voteLabel.text = rs.count
                                voted = !rs.status
                            }
                        })
                    }
                }

                Label {
                    id: voteLabel
                    text: dataModel.vote_count || '0'
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                VoteDownButton {
                    id: voteDownBtn
                    width: Theme.iconSizeMedium
                    anchors.horizontalCenter: parent.horizontalCenter
                    voted: votes[dataModel.id] === -1
                    onClicked: {
                        if (loading) return
                        loading = true

                        py.call('app.api.do_vote', [dataModel.id, 6], function(rs){
                            loading = false

                            if (rs && rs.success === 1){
                                voteLabel.text = rs.count
                                voted = !rs.status
                            }
                        })
                    }
                }
            }

            Column {
                id: rightCol
                width: parent.width - leftCol.width - (2 * Theme.paddingMedium)

                Label {
                    text: dataModel.content
                    color: Theme.primaryColor
                    linkColor: Theme.highlightColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: settings.fontSize === 1 ? Theme.fontSizeSmall : Theme.fontSizeMedium
                    width: parent.width
                    onLinkActivated: Utils.handleLink(link)
                }
            }
        }

        Hr {
            width: parent.width
            paddingBottom: Theme.paddingMedium
            paddingTop: Theme.paddingMedium
        }

        ListView {
            id: commentsListView
            interactive: false
            height: contentHeight
            width: parent.width

            model: ListModel {
                id: commentsModel
            }

            delegate: Item {
                width: commentsListView.width
                height: comments.height + (commentsHr.visible ? commentsHr.height : 0)

                Comment {
                    id: comments
                    dataModel: model
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall + Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingMedium
                    onDeleted: commentsModel.remove(index)

                    Hr {
                        id: commentsHr
                        paddingTop: Theme.paddingMedium
                        paddingBottom: Theme.paddingMedium
                        anchors.top: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }
            }
        }

        CommentButton {
            text: dataModel.has_more_comments === true ? qsTr('see more comments') : (app.isLoggedIn ? qsTr("add a comment") : qsTr("login to comment"))
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall + Theme.paddingMedium
            anchors.right: parent.right
            padding: Theme.paddingMedium
            onClicked: {
                if (dataModel.has_more_comments){
                    loading = true
                    py.call('app.api.get_comments', [dataModel.id, 'answer'], function(rs){
                        loading = false
                        if (rs && rs.length){
                            dataModel.has_more_comments = false

                            var comments = []
                            for (var i=0; i<commentsModel.count; i++){
                                comments.push(commentsModel.get(i).id)
                            }

                            for (var i=0; i<rs.length; i++){
                                if (comments.indexOf(rs[i].id) === -1){
                                    commentsModel.append(rs[i])
                                }
                            }
                        }
                    })
                }else if (app.isLoggedIn){
                    visible = false
                    commentField.visible = true
                    commentField.focus()
                }else{
                    pageStack.push(Qt.resolvedUrl("../pages/LoginPage.qml"))
                }
            }
        }

        CommentField {
            id: commentField
            anchors.left: parent.left
            anchors.leftMargin: Theme.horizontalPageMargin + Theme.itemSizeSmall + Theme.paddingMedium
            anchors.right: parent.right
            topMargin: Theme.paddingMedium
            visible: false
            onSubmit: {
                if (text.trim().length < 10){
                    return
                }

                commentField.loading = true

                py.call('app.api.do_comment', [{comment: text.trim(), post_type: 'answer', post_id: dataModel.id}], function(rs){
                    if (rs && rs.length){
                        commentField.reset()

                        var comments = []
                        for (var i=0; i<commentsModel.count; i++){
                            comments.push(commentsModel.get(i).id)
                        }

                        for (var i=0; i<rs.length; i++){
                            if (comments.indexOf(rs[i].id) === -1){
                                commentsModel.append(rs[i])
                            }
                        }
                    }
                })
            }
        }

        Hr {
            width: parent.width
            paddingTop: Theme.paddingMedium
        }
    }

    Component.onCompleted: {
        if (dataModel){
            if (dataModel.comments){
                for (var i=0; i<dataModel.comments.count; i++){
                    commentsModel.append(dataModel.comments.get(i))
                }
            }
            if (dataModel.users){
                for (var i=0; i<dataModel.users.count; i++){
                    usersModel.append(dataModel.users.get(i))
                }
            }
        }
    }
}
