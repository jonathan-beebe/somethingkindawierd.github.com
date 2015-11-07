//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

let value = context.evaluateScript(
    "[1,2,3,4,5].map(function(n){return n*n})"
)

func handleJavaScriptArray(value:JSValue) -> Void {
    guard let array = value.toArray() as? [Int] else {
        print("error casting array")
        return
    }

    // Proceed knowing that `array` is the value type you expected

    print("success casting array", array)
}

handleJavaScriptArray(value)

// - Try inputing a string into the javascript array and see how it is cast

//: [Next](@next)
