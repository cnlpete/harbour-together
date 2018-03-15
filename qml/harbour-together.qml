import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import lbee.together.core 1.0
import "pages"

ApplicationWindow
{
    initialPage: Component { QuestionsPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Settings {
        id: settings
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'))

            setHandler('log', function(msg){
                console.log(msg)
            })

            importModule('app', function(){})
        }
    }
}
