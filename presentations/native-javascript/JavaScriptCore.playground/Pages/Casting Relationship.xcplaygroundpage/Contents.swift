//: [Previous](@previous)

//: From “Converting to Objective-C Types” in [`JSValue.h`](http://trac.webkit.org/browser/trunk/Source/JavaScriptCore/API/JSValue.h)

//   Objective-C type  |   JavaScript type
// --------------------+---------------------
//         nil         |     undefined
//        NSNull       |        null
//       NSString      |       string
//       NSNumber      |   number, boolean
//     NSDictionary    |   Object object
//       NSArray       |    Array object
//        NSDate       |     Date object
//       NSBlock (1)   |   Function object (1)
//          id (2)     |   Wrapper object (2)
//        Class (3)    | Constructor object (3)

//: Let’s focus on note 2 on Wrapper Objects…

//: [Next](@next)
