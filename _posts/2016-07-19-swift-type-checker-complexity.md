---
title: Exponential time complexity in the Swift type checker
date: 2016-07-19
tags: swift
---

Matt Gallagher has created an incredible article on Cocoa with Love about a [Swift compiler issue](http://www.cocoawithlove.com/blog/2016/07/12/type-checker-issues.html).

> Try compiling the following line:
> 
> ```swift
> let x = { String("\($0)" + "") + String("\($0)" + "") }(0)
> ```
> 
> This single line does compile without error but it takes around 4 seconds to compile in Swift 2.3 and a whopping 15 seconds to compile in Swift 3 on my computer. The compiler spends almost all of this time in the Swift type checker.

When I tried the above line in the newest Xcode 8 Beta 3 it took a _long_ time to finally fail with this message:

```
Playground execution failed: error: Temp Playground.playground:1:9: error: expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions
```

The specific problem as identified by Matt in his article:

> In general, Swift’s complexity problem won’t be an issue unless you’re using two or more of the following features in a single expression:
> 
> - overloaded functions (including operators)
> - literals
> - closures without explicit types
> - expressions where Swift’s default “every integer literal is an Int and every float literal is a Double” choice is wrong
>
> If you don’t typically combine these features in your code, then you’re unlikely to see the “expression was too complex” error. 

Matt’s post is incredibly thorough and full of details. You should check it out if you write Swift.

This is the kind of thing I will so easily forget between now and when I actually trigger the error in my own code. I’m filing this one as a good-to-know, so hopefully when I do encounter this error I _will_ remember.
