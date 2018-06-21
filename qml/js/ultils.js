function handleLink(link) {
    console.log("Open link: " + link);

    if (link.indexOf("together.jolla.com/question/") > -1){
        var id = parseQuestionId(link);
        if (id){
            py.call("app.main.get_question_id", [{id: id}], function(data){
                if (data){
                    py.call('app.main.markdown', [data.body], function(html){
                        data.body = html
                        pageStack.push(Qt.resolvedUrl("../pages/QuestionPage.qml"), {question: data})
                    });
                }
            });
        }
    }else{
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
