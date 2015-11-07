//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
context.exceptionHandler = { context, exception in
    let error = exception
    print("JS Error: \(error)")
}

//: Export the class for use in javascript

context.setObject(Point.self, forKeyedSubscript: "Point")

//: [Next](@next)
