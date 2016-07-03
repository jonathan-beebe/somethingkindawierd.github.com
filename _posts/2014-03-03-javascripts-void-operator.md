---
published: true
title: "Javascript’s void Operator"
---

**What is the purpose of `obj === void 0` or `void(alert(…))`?**

I’ve seen code like this floating around the internet, always thinking the expression was a function all to `void()`:

```js
<a href="javascript:void(alert('Warning!!!'))">Click me!</a>
```

Nope.

`void` [is an operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators), akin to `typeof`, `instanceof`, and `new`. The `void` operator specifies an expression to be evaluated without returning a value from the expression.

It *always* returns `undefined`.

## Is this useful?

Since we know the `undefined` property can be manipulated in older browsers and we can use it as a custom variable name, let’s see if we can have some fun.

I’ve created an iife, manually overriding the property `undefined` to be `true`. The 2nd parameter is actually undefined since we did not pass it value when invoking the function.

```js
(function(undefined, reallyUndefined) {
  console.log(undefined === true);              // true
  console.log(undefined === reallyUndefined);   // false
  console.log(reallyUndefined === void 0);      // true
}(true));
```

So we can’t rely on `undefined` to be truly undefined. But we *can* rely on the return value of `void 0` to be undefined.

And that is why you can find `void 0` in unexpected places, such as all over the [underscore.js source](http://underscorejs.org/docs/underscore.html#section-124)

```js
 _.isUndefined = function(obj) {
  return obj === void 0;
};
```
