//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()
let jsv = context.evaluateScript(
    "obj = {x: 1, y: 8};"
)

//: But what if we know the specific types?

var typedDict:[String: Int];

//: And then we try to simply cast to a dictionary?

typedDict = jsv.toDictionary()

//: error: cannot assign a value of type '[NSObject : AnyObject]!' to a value of type '[String : Int]'

//: [Next](@next)

