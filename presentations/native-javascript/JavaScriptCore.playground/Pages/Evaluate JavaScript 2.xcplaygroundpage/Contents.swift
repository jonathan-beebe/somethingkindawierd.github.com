//: [Previous](@previous)

import Foundation
import JavaScriptCore

//: 1. Create a JavaScript context

let context = JSContext()

//: 2. Evaluate a script

context.evaluateScript("[1,2,3,4,5]")
context.evaluateScript("nonsense * nonsense")
context.evaluateScript("this")

//: [Next](@next)
