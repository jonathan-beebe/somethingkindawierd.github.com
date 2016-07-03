---
published: true
title: "React + Value Transforms"
---

After a short time with Facebook's [React](http://facebook.github.io/react/) I found the need to intercept the properties coming into my components so I could transform them appropriately. Eventually I settled on a pattern involving value transformers. But before I discuss that let's look at how properties work in React.

## A Basic Component

Let's imagine we need a `<Clock>` component that renders the time.

```js
var Clock = React.createClass({
  render: function () {
    var date = new Date()
    return <span>{date.toString()}</span>;
  }
});
```

This is a good start, but we need to accept dynamic `date` values from the users of our component. We must handle 3 scenarios:

1. No properties defined `<Clock />`
2. Properties defined at creation time `<Clock date={date} />`
3. Properties changing during runtime

We can handle all 3 of these by simply defining the default `date` value. React does the rest for us.

```js
var Clock = React.createClass({
  getDefaultProps: function () {
    return {
      date: new Date()
    }
  },
  render: function () {
    return <span>{this.props.date.toString()}</span>;
  }
});

...

var clock = React.renderComponent(
  <Clock />,
  document.body
);

...

window.setInterval(function () {
  clock.setProps({
    date: new Date()
  });
}, 1000);
```

As the `date` property changes during runtime React will automatically re-render the component for us, thanks to its incredibly fast [Virtual DOM, which Pete Hunt describes](https://www.youtube.com/watch?v=h3KksH8gfcQ) much better than I.

## Add Flexibility

But what happens if the users of this component need to format the time?

Let's integrate the [moment.js](http://momentjs.com/) library and allow users to define the format:

```js
var Clock = React.createClass({
  getDefaultProps: function () {
    return {
      date: new Date(),
      format: 'h:mm:ss a'
    }
  },
  render: function () {
    var time = moment(this.props.date).format(this.props.format);
    return <span>{time}</span>;
  }
});
```

At this point we have a perfectly functioning clock component and users can override the defaults to customize it.

But in the real world things are rarely this cut-and-dry. We have users that don't or can't use moment.js and will need to customize how `time` is calculated. This is where value transformers come into play. They are, in fact, "the solution that we didn't know we needed, but was there all along" (as [Mattt Thompson describes them][2.1].)

[2.1]: http://nshipster.com/nsvaluetransformer/ "NSHipster on value transforms"

## Value Transformers

A value transformer assists in transforming an input value into some other output value. This could be used to format a number as money, or to ensure truthy or falsey values become a bona fide boolean, or to format a date into 24-hour military time. iOS and Mac developers might recognize this idea as it's heavily inspired by the [NSValueTransformer][3.1].

[3.1]: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSValueTransformer_Class/Reference/Reference.html "iOS NSValue Transformer"

In its purest form a value transformer is a simple function mapping an input to an output value. For example, to transform values into a literal boolean you could use this, taking advantage of the [double-not][3.2]:

[3.2]: http://stackoverflow.com/questions/784929/what-is-the-not-not-operator-in-javascript "What is the not-not operator in Javascript?"

```js
var boolTransform = function (value) {
  return !!value;
}
```

While a plain-old-function works I'd prefer a more object-oriented approach, akin to NSValueTransformer. Let's start by defining an object for transforming one value into another. This basic transform returns the stringified version of the input if possible, otherwise it returns the original input.

```js
// A simple class to capture a one-way value transform function.
var ValueTransformer = function (transform) {
  this.func = (typeof transform === 'function')
  ? transform
  : function (value) { return value.toString ? value.toString() : value; }
};

// Transforms the input value according to the pre-defined transform function
ValueTransformer.prototype.getTransformedValue = function (value) {
  return this.func.call(null, value);
};
```

Using our moment.js code from our `Clock` above we can now define the transform like this, a subtle but significant improvement over our use of moment.js before:

```js
var transform = new ValueTransformer(function (date) {
  return moment(date).format('h:mm:ss a');
});
```

And here is how we can use it:

```js
var formattedTime = transform.getTransformedValue(new Date());
// 12:34:36 pm
```

Now let's pair it with our React clock, which I've updated slightly to take advantage of our value transformer:

```js
var Clock = React.createClass({
  getDefaultProps: function () {
    return {
      date: new Date(),
      dateTransform: new ValueTransformer()
    }
  },
  getTime: function () {
    return this.props.dateTransform.getTransformedValue(this.props.date);
  },
  render: function () {
    return <span>{this.getTime()}</span>;
  }
});

...

var transform = new ValueTransformer(function (date) {
  return moment(date).format('h:mm:ss a');
});

...

var clock = React.renderComponent(
  <Clock dateTransform={transform} />,
  document.body
);

```

Perfect! Now users are able to create any number of different transforms for all the time formats they need to support. As we will see in the live demo below these transforms can even include other React components and JSX in their result, allowing for complete customizeability of the output.

## Live Demo

Here is everything I've discussed up to this point wrapped up in a demo. Below you'll see the `Clock` component paired with various transforms. (All the React javascript is embedded in the html tab until we have proper `JSX` support within CodePen.)

<p data-height="550" data-theme-id="12705" data-slug-hash="chnbE" data-default-tab="html,result" data-user="somethingkindawierd" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/somethingkindawierd/pen/chnbE/">React + Value Transforms</a> by Jon Beebe (<a href="http://codepen.io/somethingkindawierd">@somethingkindawierd</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Wrap Up

I hope you've seen the value in using value transformers (yep, pun *totally* intended.) Admittedly the example used here of a `Clock` is a bit contrived, but I believe it's effective nonetheless. It's really about making sure your React components are offloading responsibilities they don't own. Transforms offer a method of encapsulating complex logic in a responsible and object-oriented way. When paired wisely with React they allow for concise components that don't care about *how* to format the data they display.

## Postscript

Why did I make the date a `prop` instead of `state`? [React has a very strong opinion][6.1] on what is a property and what is state. So let's think for a moment about the current time. Who owns that state? I'd argue that your machine is responsible for storing the current time. The system owns that state. We access the system's current time state using `Date`. Since one of our goals is to [keep React components as stateless as possible][6.2], we pass it in as a property and don't need to touch the component's `state` at all. That's why `Clock` uses `props` throughout this article.

> Originally posted at [codepen](http://codepen.io/somethingkindawierd/post/react-and-value-transform)

[6.1]: http://facebook.github.io/react/docs/interactivity-and-dynamic-uis.html "React on props vs state"
[6.2]: http://facebook.github.io/react/docs/interactivity-and-dynamic-uis.html#what-components-should-have-state "Keep React components stateless"
