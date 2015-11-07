//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

extension JSContext {
    func get(key:String)->JSValue {
        return self.objectForKeyedSubscript(key)
    }
    func set(key:String, _ val:AnyObject!) {
        self.setObject(val, forKeyedSubscript: key)
    }
}

context.set("array", [1,2,3])
context.get("array")

context.set("count", 54)
context.get("count")

//: [Next](@next)
