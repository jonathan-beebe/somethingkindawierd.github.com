//: [Previous](@previous)
//:
//: Parsing Markdown

import XCPlayground
import Foundation
import WebKit

var str = "Hello, playground"

// Create a modern webview
let webview = WKWebView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))

// Inject the Markdown library
let content = getJsScriptContent("Markdown.Converter", dir: "pagedown")
webview.evaluateJavaScript(content) { (result, error) -> Void in }

let script = "var converter = new Markdown.Converter();" +
    "var markdownText = \"# Hello World\";" +
    "converter.makeHtml(markdownText);"

// Parse markdown
webview.evaluateJavaScript(script) { (result, error) -> Void in
    let value = result
}

// Ensure playground does not exit so async operations complete.
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: [Next](@next)
