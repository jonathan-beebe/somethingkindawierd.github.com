---
title: TypeScript Without TSLint
description: Let the Compiler be Your Guide
---

I’ve learned to love compilers as a guide. In the ever-changing world of technology anything that can lighten the load of learning a new language is a blessing.

----

When I first tried TypeScript it was like trudging through knee-high mud. I am fairly proficient in JavaScript. I use Swift daily. I’m getting aquainted with Kotlin. So picking up TypeScript should feel natural. But it wasn’t. I began to feel something was wrong. Maybe something was wrong with me.

My more familiar tools, e.g. Xcode + Swift, or Kotlin + Android Studio, offer real time feedback on my code’s fitness. If I misspell something then the editor immediately underlines it. If I misformat some syntax, or forget a property, or whatever, the toolchain guides me towards the solution. Swift is particularly good at this.

_The compiler is a learning tool!_

With TypeScript I downloaded VSCode + TypeScript and dug in. And — got stuck.

I didn’t notice what was missing for a while. TypeScript just felt _hard_. I wrote some code, compiled it, and — it failed. Hmm. What had I done wrong? Guess I’ll try again. Compile. Fail. Again, and again, until it finally compiled. Awesome. _But why was it broken in the first place?_ Oh well. Add more code (like, just _one_ phrase.) Fail. Again.

I am used to constantly failing until I finally get it right. That’s normal. But this wrestling match with TypeScript was something else; trudging through mud.

Ugh. What is wrong with me? Why was it so hard to _get_ TypeScript!?

Then I had a moment of zen. I got `tslint` set up in VSCode. And _immediately_ my toolset started offering real time feedback on my TypeScript. **The compiler became my guide.**

Instead of yelling at me when my build step breaks, it offers gentle nudges _as I type_. It’s like a helpful friend saying “hey, I think that thing you just typed is wrong.” And _in that moment_ I can recognize “oh yeah, that’s because i just typed the Swift syntax for a closure, not the JavaScript arrow function like I should have.” I fix it before my thoughts move on. And I learn.

So, real time compiler feedback. It’s fantastic. I love it. When it is missing _I feel it._

And TypeScript is outstanding. I just needed [VSCode](https://github.com/Microsoft/vscode) + [TypeScript](http://www.typescriptlang.org) + [TSLint](https://github.com/Microsoft/vscode-tslint).
