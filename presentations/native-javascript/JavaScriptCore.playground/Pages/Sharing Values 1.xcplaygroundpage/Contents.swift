//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Simple string interpolation

let array = [1,2,3,4,5]
let jsv = context.evaluateScript(
    "\(array).map(function(n){return n*n})"
)

//: [Next](@next)

