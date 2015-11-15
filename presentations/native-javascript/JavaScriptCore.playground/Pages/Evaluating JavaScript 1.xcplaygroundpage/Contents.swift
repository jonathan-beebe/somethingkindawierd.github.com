//: [Previous](@previous)

import Foundation
import JavaScriptCore

//: 1. Create a JavaScript context

let context = JSContext()

//: 2. Define an exception handler to aid debugging

context.exceptionHandler = { context, exception in
    let error = exception
    print("JS Error: \(error)")
}

//: 3. Evaluate a script

let jsv = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

//: [Next](@next)
