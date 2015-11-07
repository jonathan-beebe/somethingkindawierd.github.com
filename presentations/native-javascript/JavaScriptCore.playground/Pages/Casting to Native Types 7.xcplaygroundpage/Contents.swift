//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
let jsv = context.evaluateScript(
    "obj = {x: 1, y: 8};"
)

jsv.className

let dict = jsv.toDictionary()

//: [Next](@next)
