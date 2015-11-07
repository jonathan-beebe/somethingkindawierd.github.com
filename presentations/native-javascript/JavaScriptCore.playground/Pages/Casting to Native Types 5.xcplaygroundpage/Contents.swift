//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

let value = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

if let nativeArray = value.toArray() as? [String] {
    print("success casting value")
}
else {
    print("error casting value")
}

//: [Next](@next)
