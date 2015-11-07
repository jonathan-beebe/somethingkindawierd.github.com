//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Define an exception handler to aid debugging

context.exceptionHandler = { context, exception in
    let error = exception
    print("JS Error: \(error)")
}

context.evaluateScript("nonesense")

//: [Next](@next)
