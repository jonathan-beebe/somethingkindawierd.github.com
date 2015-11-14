//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Inject native object into JavaScript context

let inputArray = [1,2,3,4,5]
context.setObject(inputArray, forKeyedSubscript: "array")

//: Retrieve js value into Native context

let outputArray = context.objectForKeyedSubscript("array")
outputArray.className

//: [Next](@next)


