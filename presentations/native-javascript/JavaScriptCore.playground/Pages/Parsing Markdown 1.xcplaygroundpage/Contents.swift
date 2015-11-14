//: [Previous](@previous)
//:
//: Parsing Markdown

import Foundation
import JavaScriptCore

let ctx = JSContext()

let content = getJsScriptContent("Markdown.Converter", dir: "pagedown")
ctx.evaluateScript(content)

//: A mostly javascript approach

let script = "" +
    "var converter = new Markdown.Converter();" +
    "var markdownText = \"# Hello World\";" +
    "converter.makeHtml(markdownText);"

let html = ctx.evaluateScript(script).toString()

//: [Next](@next)
