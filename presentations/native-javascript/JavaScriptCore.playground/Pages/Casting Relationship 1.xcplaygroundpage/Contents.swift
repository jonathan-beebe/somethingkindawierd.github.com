//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
let jsv = context.evaluateScript(
    "obj = {x: 1, y: 8};"
)

var typedDict:[String: Int];
typedDict = jsv.toDictionary() as! [String: Int]

//: What happens if we modify it in Swift?

typedDict["z"] = 32

typedDict
context.evaluateScript("obj;").toDictionary()

//: [Next](@next)
