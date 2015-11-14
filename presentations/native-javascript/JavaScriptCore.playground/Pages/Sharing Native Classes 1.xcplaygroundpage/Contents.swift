//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Export the class for use in javascript

context.setObject(Point.self, forKeyedSubscript: "Point")

//: [Next](@next)
