//: [Previous](@previous)

import Foundation
import JavaScriptCore

//: 1. Create a JavaScript context

let context = JSContext()

//: 2. Evaluate a script

let jsv = context.evaluateScript(
    "1" // Returns the last value
)

//: [Next](@next)
