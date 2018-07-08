function handleLink(link, forceExternal) {
    if (!forceExternal && link.indexOf("together.jolla.com/question/") > -1){
        console.log("Internal link: " + link);
        var id = parseQuestionId(link);
        if (id){
            pageStack.push(Qt.resolvedUrl("../pages/QuestionPage.qml"), {question_id: id});
        }else{
            console.log("Could not found question ID");
        }
    }else{
        console.log("External link: " + link);
        Qt.openUrlExternally(link);
    }
}

function parseQuestionId(url){
    var regex = /together.jolla.com\/question\/(\d+)\//;
    var matches = regex.exec(url);
    if (matches[1]){
        return matches[1];
    }
}
