//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

let value = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

let nativeArray = value.toArray()

// Try typing `value.to` to see the autocomplete list that appears.

//: [Next](@next)
