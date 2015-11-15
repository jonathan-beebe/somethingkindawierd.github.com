//: [Previous](@previous)

import Foundation
import JavaScriptCore

let context = JSContext()

//: Export the class for use in javascript

context.setObject(Point.self, forKeyedSubscript: "Point")

//: Create instance of point

context.evaluateScript("var pt = Point.createXY(10, 20);")

//: Access value from JavaScript context

let pt:Point = context
    .objectForKeyedSubscript("pt")
    .toObjectOfClass(Point.self) as! Point

// Try modifying either pt object and se what happens to the other

//context.evaluateScript("pt.x = 320; pt.y = 480; pt;")
//pt

//pt.x = 320
//pt.y = 480
//context.evaluateScript("pt.x == 320 && pt.y == 480")

//: [Next](@next)
