//: [Previous](@previous)

import Foundation
import JavaScriptCore

//: 1. Create a JavaScript context

let context = JSContext()

//: 2. Evaluate a script

let jsv = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

//: [Next](@next)
