//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
let jsv = context.evaluateScript(
    "var obj = {x: 1, y: 8}; obj;"
)

var typedDict:[String: Int];
typedDict = jsv.toDictionary() as! [String: Int]

//: What happens if we modify it in JavaScript?

context.evaluateScript("obj.z = 64; obj;").toDictionary()
typedDict

//: [Next](@next)
