import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import lbee.together.core 1.0
import "pages"
import "components"

ApplicationWindow
{
    initialPage: Component { QuestionsPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Settings {
        id: settings
    }

    InfoBanner {
        id: banner
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'))

            setHandler('log', function(msg){
                console.log(msg)
            })

            setHandler('error', function(msg){
                console.log(msg)

                var text = ""
                switch (msg){
                case 'NETWORK_ERROR':
                    text = qsTr("Network problem occurred")
                    break;
                case 'CONTENT_ERROR':
                    text = qsTr("Could not get content")
                    break;
                default:
                    text = msg
                }

                banner.alert(text)
            })

            importModule('app', function(){})
        }
    }
}
