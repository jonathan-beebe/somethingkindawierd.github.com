//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

let value = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

value.className

//: `value` is not a native array…yet

//: [Next](@next)
