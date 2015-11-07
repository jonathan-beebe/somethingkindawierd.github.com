//: [Previous](@previous)
//:
//: Parsing Markdown

import Foundation
import JavaScriptCore

let ctx = JSContext()

let content = getJsScriptContent("Markdown.Converter", dir: "pagedown")
ctx.evaluateScript(content)

//: An more Swift-ish approach

// Prepare the JavaScript context
ctx.evaluateScript("converter = new Markdown.Converter();")

// Inject the markdown text
let markdown = "# Hello World"
ctx.setObject(markdown, forKeyedSubscript: "markdown")

// Convert to html
ctx.evaluateScript("html = converter.makeHtml(markdown);")
let html = ctx.objectForKeyedSubscript("html").toString()

//: [Next](@next)
