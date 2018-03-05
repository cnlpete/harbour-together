/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent

        model: ListModel{
            id: listModel
        }

        PullDownMenu{
            MenuItem{
                text: qsTr("Refresh")
                onClicked: {
                    listModel.clear()
                    py.call('app.app.get_questions')
                }
            }
        }

        header: PageHeader {
            title: qsTr("Questions")
        }

        delegate: BackgroundItem {
            id: delegate
            height: titleLbl.height + authorLbl.height + Theme.horizontalPageMargin

            Column{
                anchors {
                    fill: parent
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    topMargin: Theme.horizontalPageMargin / 2
                    bottomMargin: Theme.horizontalPageMargin / 2
                }

                Label {
                    id: titleLbl
                    text: title
                    width: parent.width
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                }
                Rectangle{
                    width: parent.width
                    height: authorLbl.height
                    color: "transparent"

                    Label {
                        id: authorLbl
                        text: qsTr("by") + " " + author
                        anchors.left: parent.left
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    Label {
                        id: voteLbl
                        text: score + " " + (score > 1 ? qsTr("votes") : qsTr("vote"))
                        anchors.right: answerLbl.left
                        anchors.rightMargin: Theme.horizontalPageMargin
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    Label {
                        id: answerLbl
                        text: answer_count + " " + (answer_count > 1 ? qsTr("answers") : qsTr("answer"))
                        anchors.right: parent.right
                        color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl("QuestionPage.qml"), {question: model})
        }

        VerticalScrollDecorator {}
    }

    BusyIndicator {
        id: busy
        visible: !listModel.count
        running: true
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        py.setHandler('questions.finished', function(rs){
            for (var i=0; i<rs.length; i++){
                listModel.append(rs[i])
            }
        })

        py.call('app.main.get_questions')
    }
}
