//: [Previous](@previous)
//:
//: Parsing Markdown

import Foundation
import WebKit

var str = "Hello, playground"

// Create a webview
let webview = WebView()

// Borrow the context from the webview
let ctx = JSContext(JSGlobalContextRef: webview.mainFrame.globalContext)

// Inject the Markdown library
let content = getJsScriptContent("Markdown.Converter", dir: "pagedown")
ctx.evaluateScript(content)

// Parse markdown
let script = "var converter = new Markdown.Converter();" +
    "var markdownText = \"# Hello World\";" +
    "var markdownHtml = converter.makeHtml(markdownText);" +
    "markdownHtml;"

let value:JSValue = ctx.evaluateScript(script)
let string:String = value.toString()

//: [Next](@next)
