//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Inject native array into JavaScript context

let array = [1,2,3,4,5]
context.setObject(array, forKeyedSubscript: "array")

//: Overwrite the array

context.evaluateScript(
    "array = array.map(function(n){return n*n})"
)

//: Pull array back into native context

let mappedArray = context.objectForKeyedSubscript("array")

mappedArray.className

//: Note that `JSValue` holds a [strong reference](http://trac.webkit.org/browser/trunk/Source/JavaScriptCore/API/JSValue.h) to its `JSContext`.
//:
//: Do not retain `JSValue` objects within the Native context.

//: [Next](@next)


