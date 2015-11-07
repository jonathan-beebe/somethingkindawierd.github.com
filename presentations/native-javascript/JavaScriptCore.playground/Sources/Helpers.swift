import Foundation

public func getJsScriptContent(name:String, dir:String) -> String {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "js", inDirectory: dir)
    let contentData = NSFileManager.defaultManager().contentsAtPath(path!)
    return (NSString(data: contentData!, encoding: NSUTF8StringEncoding) as? String)!
}