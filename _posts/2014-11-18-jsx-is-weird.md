---
published: true
title: "JSX is Weird"
---

# JSX is Weird

I'm a huge fan of Facebook's React library. So much a fan that it got me out of my comfortable bubble and out into the [javascript speaker circuit.](https://www.youtube.com/user/nodevember) (Well, [Elijah Manor](https://twitter.com/elijahmanor) had a bit to do with it too.)

But I'm just gonna say it — JSX is weird. It's markup in javascript. Over the past decade a lot of ink has been spilled about keeping our Javascript unobtrusive. React (and JSX) is forcing me to re-think what that means — but that doesn't stop it from feeling weird.

Not Jar Jar Binks weird. Weird-Al weird, as-in actually kinda awesome and probably better than the original.

![jsx-is-weird.jpg](https://dl.dropboxusercontent.com/u/14898/Photos/codepen.io/jsx-is-weird/jsx-is-weird.jpg)

Yes, you could view JSX as markup in your javascript. But there's a better way to look at it.

## Separation of Concerns

In React a **component** is the primary method of separating concerns. You don't think in terms of view classes and template files, which separate technical concerns. Instead you break apart your app into individual components that each capture a distinct business or UI/UX concern. Each of these components serves to encapsulate the display logic and the markup it generates.

I digress into this discussion because it's at the heart of why JSX is so weirdly awesome in React. You separate concerns so you don't repeat yourself and so edits require touching as few files as possible, ideally only one file. JSX aids us in this endeavor.

So you can start to think of nodes in your markup as individual concerns. Need to layout the main sections of the page? Use a Layout component — it may not render html but it will organize other React components. Need to encapsulate your nav? Create a Nav component.

When thinking in JSX you have to move away from the DOM. There is no direct mapping from JSX to html DOM nodes. In many cases React components provide no ui themselves. Instead they compose other components. This aspect of JSX can take some getting used to — just because it looks like markup does not mean it actually renders html markup.

## An Example

Consider this completely contrived example of a basic news site that renders a top nav, an article, and a footer. You might organize the component tree like this.

```html
<Main>
  <Layout>
    <Nav>...</Nav>
    <Article>...</Article>
    <Footer>...</Footer>
  </Layout>
</Main>
```

Here `Main` might be implemented as a controller-view that loads the data and initializes a layout.

```js
var Main = React.createClass({
  render: function () {
    return (
      <Layout>
        <Article data={this.props.data} />
      </Layout>
    );
  }
});
```

`Main` is rendering other React components. When inspecting the rendered DOM you will not find `Main`, `Layout`, or `Article` tag names since they are not actually html, but are virtual components within React (notice they are capitalized and do not correspond to html5 `main` or `article` tag names.) The actual work of rendering html tags occurs deeper within the component hierarchy.

Next is the `Layout` component that is composed of both React components and html tags to form the nav, content, and footer. While the `Layout` component knows about the `Nav` and `Footer` it knows nothing about the main content (because that's not its concern.) It's just passing along the components it received as child nodes above.

```js
var Layout = React.createClass({
  render: function () {
    return <div>
      <Nav />
      <main>{this.props.children}</main>
      <Footer />
    </div>;
  }
});
```

Now we have two divergent component trees: the React virtual DOM and the actual html DOM that React will render. The two look like this side-by-side:

```html

React Virtual DOM             |    HTML DOM
                              |
<Main>                        |    <body>
  <Layout>                    |      <div>
    <Nav>...</Nav>            |        <nav>...</nav>
    <Article>...</Article>    |        <main>
    <Footer>...</Footer>      |          <article>...</article>
  </Layout>                   |        </main>
</Main>                       |        <footer>...</footer>
                              |     </div>
                              |    </body>
```

The version on the left is somewhat easier to read, as each node is more semantic. This is an admittedly simple and contrived example, but I trust you can imagine how in a large app the JSX component tree quickly becomes more readable than the html tree.

This is why JSX is weirdly awesome. It's markup in Javascript, but it's very semantic, readable, and terse.

## Demo

Here is a working version of the contrived news site I've been referencing. You can explore this to compare the React components and their use of JSX to assemble the virtual DOM vs the actual html DOM that is rendered.

<p data-height="600" data-theme-id="0" data-slug-hash="LEYMPQ" data-default-tab="html" data-user="somethingkindawierd" data-embed-version="2" class="codepen">See the Pen <a href="http://codepen.io/somethingkindawierd/pen/LEYMPQ/">JSX is Weird</a> by Jon Beebe (<a href="http://codepen.io/somethingkindawierd">@somethingkindawierd</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

> Originally posted at [codepen](http://codepen.io/somethingkindawierd/post/jsx-is-weird)
