//: [Previous](@previous)
//:
//: Cleaning email with [Mailcheck](https://github.com/mailcheck/mailcheck)

import Foundation
import JavaScriptCore

let ctx = JSContext()

// Load the Mailcheck script
let content = getJsScriptContent("mailcheck", dir: "")
ctx.evaluateScript(content)

// Inject the input email
let email = "jon.beebe@gmal.co"
ctx.setObject(email, forKeyedSubscript: "email")

// Check email address
let raw = ctx.evaluateScript("Mailcheck.run({email:email});")

if let result = raw.toDictionary() {
    print("suggested", result["full"]!)
}
else {
    print("no suggestions")
}


//: [Next](@next)
