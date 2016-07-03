---
title:  "Swift Suprises"
date:   2014-07-29 10:18:00
description: After spending a weekend playing with Swift I encountered a few surprises.
tags: swift development
published: true
---

After spending a weekend playing with [Swift][swift] I encountered a few surprises.

[swift]: https://developer.apple.com/swift/

## Categories & Extensions

Categories are one of my favorite features of Objective-C. I can modify the behavior of any class.

Swift doesn't have categories. Instead it has [extensions][ex]. I was immediately surprised to find extensions are available throughout the entire app target (whereas categories are only available if and where you include them.)

[ex]: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html

## Compatibility

Ever since the announcement I wondered how Apple is able to support past devices. After all, iOS7 and OS X 10.9 were released with pre-Swift runtimes. Turns out Swift apps [embed the Swift runtime in *each* app bundle][2], which is how they are able to run consistently and predictably on past, present, and future devices, even while the language is experiencing the churn of a beta release.

Which brings me to the next point...

## Expect Change

We've already seen a lot of changes and tweaks to the language since it's announcement. 

And Apple [expects Swift to change alot][2] over the next two years. 

[2]: https://developer.apple.com/swift/blog/?id=2

> It would be dangerous to rely upon binary frameworks that use Swift — especially from third parties. As Swift changes, those frameworks will be incompatible with the rest of your app. When the binary interface stabilizes in a year or two, the Swift runtime will become part of the host OS and this limitation will no longer exist.

## Privacy

For seven releases of iOS we've never had private access control in our classes. As of XCode 6 beta 4 that changes — we now have [truly private access control][5]. This is certainly a new and welcome addition to the world of iOS development!

[5]: https://developer.apple.com/swift/blog/?id=5
