//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Inject native object into JavaScript context

let array = [1,2,3,4,5]
context.setObject(array, forKeyedSubscript: "array")

let jsv = context.evaluateScript(
    "array.map(function(n){return n*n})"
)

//: [Next](@next)


