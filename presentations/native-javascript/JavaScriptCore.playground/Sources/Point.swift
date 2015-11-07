import Foundation
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol PointProtocolJSExport: JSExport {
    var x:Int { get set }
    var y:Int { get set }
    static func createX(x: Int, y: Int) -> Point
}

@objc
public class Point: NSObject, PointProtocolJSExport, CustomDebugStringConvertible {
    dynamic public var x:Int
    dynamic public var y:Int

    public init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }

    public class func createX(x: Int, y: Int) -> Point {
        return Point(x: x, y: y)
    }

    override public var description: String {
        return "{x:\(x), y:\(y)}"
    }

    override public var debugDescription: String {
        return "{x:\(x), y:\(y)}"
    }
}
