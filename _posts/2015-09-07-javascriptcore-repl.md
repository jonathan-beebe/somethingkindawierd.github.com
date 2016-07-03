---
title:  "JavaScriptCore REPL"
date:   2015-09-07 09:07:00
description: Try out Apple’s built-in JavaScriptCore REPL in OS X
published: true
tags: javascript
---

Apple seems to have a complicated relationship with JavaScript. It is the first non-Apple language officially supported for developing native apps [^1] (both OS X & iOS) and is a first-class scripting language sitting besides AppleScript [^2]. However it seems to have crept in slowly, silently, and remains a rather under-documented and under-utilized technology.

That’s not to say there aren’t people doing amazing things with it. It just seems that most JavaScript devs use Node, and most native devs, if they use JavaScript, don’t give it the same prominence as the native languages.

Perhaps the most significant sign of this is most developers have no idea Mac OS X ships with a JavaScript REPL. It’s fairly well-hidden.

## Access the Built In REPL

While not as powerful for development as Node, JavaScriptCore is a framework installed on every modern Mac. You will find it here:

    /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc

It’s most convenient to link it to your local bin folder.

    ln -s /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc /usr/local/bin/jsc

Now you can start the REPL by simply calling `jsc`. Then you can begin invoking JavaScript.

```javascript
jsc
>>> var pt = {x:10, y:20}
undefined
>>> pt
[object Object]
>>> JSON.stringify(pt)
{"x":10,"y":20}
```

Type `ctrl-c` to exit the REPL.

As of this writing, Sept 2015, the default version does not support much (or any?) ES6 JavaScript, even on the OS X 10.11 beta.

But there are two other ways to get JavaScriptCore on your machine *with* ES6 support.

## Install WebKit Nightly Builds

The easiest way to get the most modern JavaScriptCore is to simply download the [WebKit Nightly Build](http://nightly.webkit.org) and link to its embedded JavaScriptCore framework.

After installing it into your Applications folder link it to your local bin folder. You might have to adjust the path if they change the nighly build process.

    ln -s /Applications/WebKit.app/Contents/Frameworks/10-10/JavaScriptCore.framework/Versions/A/Resources/jsc /usr/local/bin/jsc-nightly

Now you can run ES6 JavaScript in the REPL.

```javascript
jsc-nightly
>>> class Point {
...   constructor(x, y) {
...     this.x = x;
...     this.y = y;
...   }
... }
function Point(x, y) {
    this.x = x;
    this.y = y;
  }
>>> let pt = new Point(10, 20)
undefined
>>> pt
[object Object]
>>> JSON.stringify(pt)
{"x":10,"y":20}
```

## Install From Source

If you are really adventurous or want to customize JavaScriptCore you can build it from source. It’s actually not very difficult. Just time-intensive. The instructions are fairly well documented at [trac.webkit.org](https://trac.webkit.org/wiki/FTLJIT), but I have aggregated them here to save you some time hunting.

In your terimnal:

```sh
# This snapshot is updated every 6 hours and
# is faster to download than the full svn repo
wget http://nightly.webkit.org/files/WebKit-SVN-source.tar.bz2
# Decompress the download--will take some time
bzip2 -d WebKit-SVN-source.tar.bz2
tar xvf WebKit-SVN-source.tar
cd webkit
# Compile JavaScriptCore ensuring the FTL compiler is enabled
Tools/Scripts/build-jsc --ftl-jit --debug
```

Now, from the same `webkit` directory, you can run the REPL. Notice that you need to set the `DYLD_FRAMEWORK_PATH` environment variable to run your custom build.

```sh
DYLD_FRAMEWORK_PATH=WebKitBuild/Debug WebKitBuild/Debug/jsc
```

## Afterward

I hope this piqued your curiosity about Apple’s built-in JavaScript framework & REPL, JavaScriptCore. While not meant to replace Node, it is convenient for hacking on an algorithm or exploring the language.

And it goes far beyond a simple REPL. I encourage you to explore the options using `jsc --help` and `jsc --options`. It includes many flags that can do interesting things, such as enabling or disabling various JIT compilers, or profiling your javascript.

Happy hacking.

[^1]: https://strongloop.com/strongblog/apples-ios7-native-javascript-bridge/
[^2]: https://developer.apple.com/library/prerelease/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/Introduction.html
