---
title:  "React Mixin — Scroll Lock"
date:   2014-08-09 10:18:00
description: Do What I Meant, Not What I Said
published: true
---

# Do What I Meant, Not What I Said

The sci-fi of my childhood promised computers that would do what I meant, not *exactly what I said*. You know that feeling — when you *know* what you want your computer to do, but no matter how hard you try it misunderstands. After more than a decade of programming the web I still run up against my browser blindly doing what I told it to do, not doing what I *meant* for it to do. These behaviors frustrate and break an otherwise elegant user experience.

Scrolling is one of these frustrating behaviors. You start scrolling on an element only to hit the bottom and have the outer context (often the `<body>`) start scrolling unexpectedly. It's a classic example of the computer doing what you told it to do, not what you meant it to do.

This can be particularly problematic in web-apps where we want the body to scroll naturally, but we have nested contexts that need to scroll independently. A good example is sidebar navigation.

Here is a demo of the problem. Try scrolling in the upper-left view. When you get to the extreme top or bottom watch as the background (`<body>`) continues the scroll event. If you needed the information on the right as context for the work you sought to do on the left, this excess scrolling immediately frustrates the user experience.

<p data-height="300" data-theme-id="0" data-slug-hash="kyuac" data-default-tab="result" data-user="somethingkindawierd" class='codepen'>See the Pen <a href='http://codepen.io/somethingkindawierd/pen/kyuac/'>Nested Scrolling Contexts</a> by Jon Beebe (<a href='http://codepen.io/somethingkindawierd'>@somethingkindawierd</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

The fix *seems* simple — just trap the `scroll` event and cancel it. But alas, [`scroll` is not cancelable][1]! Time to start hacking.

I created a script to [render the order of mouse events][5] and found `wheel` occurs before `scroll`.

Turns out we *can* trap `wheel` events and cancel them. Canceling a `wheel` event prevents the `scroll` event. Awesome!

After this the only tricky part is discovering which direction the user is scrolling and if they've hit a boundary of the scroll. Only if they're scrolling in the proper direction and have hit the boundary do we want to cancel the scroll.

I've made a handy little React `ScrollLockMixin` to encapsulate this behavior. For any scrollable component you can add the mixin and wire up the mount and dismount methods as appropriate. Automagically the browser seems to do what I mean.

```js
var cancelScrollEvent = function (e) {
  e.stopImmediatePropagation();
  e.preventDefault();
  e.returnValue = false;
  return false;
};

var addScrollEventListener = function (elem, handler) {
  elem.addEventListener('wheel', handler, false);
};

var removeScrollEventListener = function (elem, handler) {
  elem.removeEventListener('wheel', handler, false);
};

var ScrollLockMixin = {
  scrollLock: function (elem) {
    elem = elem || this.getDOMNode();
    this.scrollElem = elem;
    addScrollEventListener(elem, this.onScrollHandler);
  },
  
  scrollRelease: function (elem) {
    elem = elem || this.scrollElem;
    removeScrollEventListener(elem, this.onScrollHandler);
  },
  
  onScrollHandler: function (e) {
    var elem = this.scrollElem;
    var scrollTop = elem.scrollTop;
    var scrollHeight = elem.scrollHeight;
    var height = elem.clientHeight;
    var wheelDelta = e.deltaY;
    var isDeltaPositive = wheelDelta > 0;

    if (isDeltaPositive && wheelDelta > scrollHeight - height - scrollTop) {
      elem.scrollTop = scrollHeight;
      return cancelScrollEvent(e);
    }
    else if (!isDeltaPositive && -wheelDelta > scrollTop) {
      elem.scrollTop = 0;
      return cancelScrollEvent(e);
    }
  }
};
```

Using the mixin is straightforward. Just don't forget to remove the scroll events when the component unmounts from the dom.

```js
var ScrollingView = React.createClass({
  mixins: [ScrollLockMixin],
  
  componentDidMount: function () {
    this.scrollLock();
  },
  
  componentWillUnmount: function () {
    this.scrollRelease();
  },
  
  render: function () {
    return <div>...</div>;
  }
});
```

Something like this is best explained with a demo, so here is a demo with the above mixin preventing the scroll event from leaking out into the outer context.

<p data-height="500" data-theme-id="0" data-slug-hash="uhonc" data-default-tab="result" data-user="somethingkindawierd" class='codepen'>See the Pen <a href='http://codepen.io/somethingkindawierd/pen/uhonc/'>React Scroll Lock & Nested Scrolling Contexts</a> by Jon Beebe (<a href='http://codepen.io/somethingkindawierd'>@somethingkindawierd</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

## Mouse Wheel Events

The [`wheel` event][6] is fairly new and has support in most modern browsers. 

- Chrome 31
- Firefox 17
- IE 9.0
- Safari 8 (maybe earlier, but I can't verify)
- Opera?

This is good enough for my current projects. And as this is not a feature, but an enhancement, I'm not worrying about supporting the older, non-standard [`DOMMouseScroll`][2] and [`mousewheel`][3] events. MDN warns not to use either in production sites. 

[1]: https://developer.mozilla.org/en-US/docs/Web/Reference/Events/scroll
[2]: https://developer.mozilla.org/en-US/docs/DOM/DOM_event_reference/DOMMouseScroll
[3]: https://developer.mozilla.org/en-US/docs/DOM/DOM_event_reference/mousewheel
[4]: https://developer.mozilla.org/en-US/docs/Web/Events
[5]: http://jsbin.com/habuw/2/edit?js,console,output
[6]: https://developer.mozilla.org/en-US/docs/Web/Events/wheel