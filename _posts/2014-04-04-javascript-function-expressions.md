---
published: true
title: "Javascript Function Expressions"
---

Prefixing a javascript function declaration with an operator like `!` or `+` [makes it an expression](http://stackoverflow.com/questions/5827290/javascript-function-leading-bang-syntax). Specifically an [immediately-invoked function expression](http://benalman.com/news/2010/11/immediately-invoked-function-expression/).

```js
!function () {}();
```

Instead of a function declaration.

```js
function () {};
```

If you tried immediately executing a function declaration you’d see an error.

```js
function () {}();
// SyntaxError: Unexpected token (
```

It’s interesting to see how changing the operator [affects the execution speed of the function](http://jsperf.com/bang-function). Furthermore, the choice of operator affects the returned result (naturally.) We don't often think of the returned result of an iife, but if you need the result choose your prefix operator carefully.

```js
(function () {})();
// undefined

!function () {}();
// true

!function () { return false; }();
// true

!function () { return true; }();
// false

+function () {}();
// NaN

-function () {}();
// NaN

~function () {}();
// -1

~function () { return 3.1415926535; }();
-4
```
