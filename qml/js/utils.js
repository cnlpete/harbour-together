/**
 * Copyright (C) 2018 Nguyen Long.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//.pragma library

var BASE_URL = 'https://together.jolla.com'

function handleLink(link, forceExternal) {
    if (!link){
        console.log('Link is empty')
        return
    }

    link = processLink(link)

    if (!forceExternal){
        if (link.indexOf("together.jolla.com/question/") > -1){
            console.log("Internal link: " + link)
            var questionId = parseQuestionId(link)
            if (questionId){
                pageStack.push(Qt.resolvedUrl("../pages/QuestionPage.qml"), {question: {id: questionId}})
            }else{
                console.log("Could not found question ID")
            }
        }else if (link.indexOf("together.jolla.com/users/") > -1){
            console.log("Internal link: " + link)
            pageStack.push(Qt.resolvedUrl("../pages/UserPage.qml"), {user: {profile_url: link}})
        }else{
            console.log("External link: " + link)
            Qt.openUrlExternally(link)
        }
    }else{
        console.log("External link: " + link)
        Qt.openUrlExternally(link)
    }
}

function parseQuestionId(url){
    var regex = /together.jolla.com\/question\/(\d+)\//
    var matches = regex.exec(url)
    if (matches[1]){
        return matches[1]
    }
}

function processLink(link){
    if (link.indexOf('http') === 0){
        return link
    }else if (link.indexOf('//') === 0){
        return 'http:' + link
    }else if (link.indexOf('/') === 0){
        return BASE_URL + link
    }else{
        return link
    }
}
