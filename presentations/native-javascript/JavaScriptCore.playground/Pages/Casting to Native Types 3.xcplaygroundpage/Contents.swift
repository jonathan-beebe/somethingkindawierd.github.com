//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

let value = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

if let nativeArray = value.toArray() as? [Int] {
    print("success casting value")
}
else {
    print("error casting value")
}

// Try modifying the input array to see how casting behaves
//: [Next](@next)
