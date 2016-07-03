---
published: true
title: "ES6 Arrow Functions & this"
---

Working with [an incredible team](http://developwithpurpose.com) amidst the thunder, rain and humidity of a Tennessee summer, I have the distinct pleasure of writing a javascript application using ES6 Harmony — the next version of javascript due to land soon(ish).

I must admit, having become familiar with the idiosyncrasies of ES5 javascript, the [new arrow functions](http://tc39wiki.calculist.org/es6/arrow-functions/) were hard to get a feel for at first, specifically because `this` is lexically bound and is not dynamic. Arrow functions reflexively feel wrong as long as your still thinking in terms of ES5 functions.

With a traditional function there are four ways to control `this`.

1. Call as a method, e.g. `foo.methodName()` where `this === foo`
2. Call without a base, e.g. `functionName()` where `this` might be the global object or `undefined`
3. Use the `new` operator, e.g. `var foo = new Foo()` where `this === foo`
4. Force the context using `apply`, `call`, or `bind`

With arrow functions `this` is bound to the enclosing scope at creation time and *cannot be changed*. The `new` operator, `bind`, `call`, and `apply` have no effect on `this`.

Here are a couple of quick examples to demonstrate. First we create a simple arrow function bound to the scope of the global object.

```js
// Arrow function, bound to scope where it's created,
// in this case it's the global object `window`.
var f = () => {
  console.log(this === window);
}
f(); // true
```
([live example](http://www.es6fiddle.com/hxkz8kxu/))

Now consider the following object with both a traditional function and an arrow function attached.

```js
var o = {
  traditionalFunc: function () {
    // Normal function, bound as expected
    console.log('traditionalFunc this === o?', this === o);
  },
  arrowFunc: () => {
    // Arrow function, bound to scope where it's created
    console.log('arrowFunc this === o?', this === o);
    console.log('arrowFunc this === window?', this === window);
  }
};

o.traditionalFunc();
// traditionalFunc this === o? true

o.arrowFunc();
// arrowFunc this === o? false
// arrowFunc this === window? true
```
([live example](http://www.es6fiddle.com/hxkz9fnn/))

The arrow function attached to `o` was *created* in the scope of `window` and *run* in the scope of `o`. This arrow function is forever bound to the scope of `window` where it was created.

> I want to pause here and note we would not normally use arrow functions as object properties in ES6. There is a better shorthand for [property method assignment](https://github.com/google/traceur-compiler/wiki/LanguageFeatures#property-method-assignment).

When I first started using arrow functions I carelessly used them everywhere, thinking they were simply shorthand for a normal function. However the above sample points to the bugs this can create. `this` is hard enough to control in ES5 and I quickly learned I don't need to make it harder on myself by carelessly introducing *another* way to affect `this`.

## Lexical Scoping

Let's take a step back and look at how we control the lexical scope of a function in ES5. When dealing with asynchronous code we need to ensure our callbacks have the proper scope and can access the variables they need. Without intentional control of the context we can run into unexpected errors.

```js
var asyncFunction = (param, callback) => {
  window.setTimeout(() => {
    callback(param);
  }, 1);
};

// With a traditional function if we don't control
// the context then can we lose control of `this`.
var o = {
  doSomething: function () {
    // Here we pass `o` into the async function,
    // expecting it back as `param`
    asyncFunction(o, function (param) {
      // We made a mistake of thinking `this` is
      // the instance of `o`.
      console.log('param === this?', param === this);
    });
  }
};

o.doSomething(); // param === this? false
```

As you can see in the above example we lost control of `this` in our callback function.

In ES5 there are two ways to ensure the context. We can either

- create a reference to `this` within the lexical scope of the callback or
- we can change the context of the function forcing `this` at will

Here we try the first option, creating a reference to `this` as `self`.

```js
var asyncFunction = (param, callback) => {
  window.setTimeout(() => {
    callback(param);
  }, 1);
};

// Define a reference to `this` outside of the callback,
// but within the callback's lexical scope
var o = {
  doSomething: function () {
    var self = this;
    // Here we pass `o` into the async function,
    // expecting it back as `param`
    asyncFunction(o, function (param) {
      console.log('param === this?', param === self);
    });
  }
};

o.doSomething(); // param === this? true
```

Thankfully after `bind` became available we could forgo creating the reference to `self`.

```js
var asyncFunction = (param, callback) => {
  window.setTimeout(() => {
    callback(param);
  }, 1);
};

// Here we control the context of the callback using
// `bind` ensuring `this` is correct
var o = {
  doSomething: function () {
    // Here we pass `o` into the async function,
    // expecting it back as `param`
    asyncFunction(o, function (param) {
      console.log('param === this?', param === this);
    }.bind(this));
  }
};

o.doSomething(); // param === this? true
```

But now we can throw out all that `self = this` and `.bind` juggling! Here is the same code using an ES6 arrow function to ensure `this` never changes.

```js
var asyncFunction = (param, callback) => {
  window.setTimeout(() => {
    callback(param);
  }, 1);
};

var o = {
  doSomething: function () {
    // Here we pass `o` into the async function,
    // expecting it back as `param`.
    //
    // Because this arrow function is created within  
    // the scope of `doSomething` it is bound to this
    // lexical scope.
    asyncFunction(o, (param) => {
      console.log('param === this?', param === this);
    });
  }
};

o.doSomething(); // param === this? true
```
([live example](http://www.es6fiddle.com/hxkzslyh/))

## Traceur

We can use the above ES6 sample today using the [traceur transpiler][traceur] from Google. In fact, if we paste the above code into the [traceur repl][repl] we get this ES5 output:

```js
$traceurRuntime.ModuleStore.getAnonymousModule(function() {
  "use strict";
  var asyncFunction = (function(param, callback) {
    window.setTimeout((function() {
      callback(param);
    }), 1);
  });
  var o = {doSomething: function() {
      var $__17 = this;
      asyncFunction(o, (function(param) {
        console.log('param === this?', param === $__17);
      }));
    }};
  o.doSomething();
  return {};
});
```

Notice that snippet `var $__17 = this;`. Traceur has automatically created a link to `this` and called it `$__17` similar to how we referenced `this` as `self` above.

## Real Life?

How might we use arrow functions in real life? In practice my team and I now using them more than traditional functions. Often it's as callbacks as in the following snippet sorting an array of objects by date.

```js
data = _sortBy(data, (item) => item.UTCDate.getTime()).reverse();
```

Some common uses throughout our codebase are:

- Array manipulation, e.g. mapping or reducing
- Utility functions such as string manipulation or math helpers
- Networking and asynchronous callbacks

In many of these scenarios, when the api to the callbacks is designed properly, we don't care what `this` is. The function only acts on the inputs and never references `this` at all.

> Originally posted on [codepen](http://codepen.io/somethingkindawierd/post/es6-arrow-functions-this)

----

# About ES6

ES6, or *Harmony* / *ES.next* as it has been code named, is the next version of javascript slated to be released...soon (I've seen references targeting [late 2014][z.1].) If you really want to get lost in the weeds you can find the official [draft spec on the ECMAScript wiki][z.2]. All the discussion around the spec [is also public][z.3].

After completing the spec we still have a long road ahead to full browser support. You can view the current status of modern browsers in this [ECMAScript 6 compatibility table][compat].

In the mean time you can use most of ES6 through the [traceur transpiler][traceur] from Google. The [traceur repl][repl] and [es6fiddle][fiddle] are two great tools for getting into ES6 and traceur right away.

[z.1]: https://github.com/rwaldron/tc39-notes/blob/48c5d285bf8bf0c4e6e8bb0c02a7c840c01cd2ff/es6/2013-03/mar-13.md#416-current-status-of-es6
[z.2]: http://wiki.ecmascript.org/doku.php?id=harmony:specification_drafts
[z.3]: https://mail.mozilla.org/pipermail/es-discuss/
[fiddle]: http://www.es6fiddle.com
[compat]: http://kangax.github.io/compat-table/es6/
[traceur]: https://github.com/google/traceur-compiler
[repl]: http://google.github.io/traceur-compiler/demo/repl.html
