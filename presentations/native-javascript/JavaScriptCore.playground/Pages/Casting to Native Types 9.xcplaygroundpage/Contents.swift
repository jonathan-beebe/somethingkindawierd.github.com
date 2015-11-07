//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
let jsv = context.evaluateScript(
    "var obj = {x: 1, y: 8}; obj;"
)

//: But what if we know the specific types?

var typedDict:[String: Int];

//: We must cast the result to the proper types

typedDict = jsv.toDictionary() as! [String: Int]

//: [Next](@next)
