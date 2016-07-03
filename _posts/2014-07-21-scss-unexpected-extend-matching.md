---
published: true
title: "The Unexpected @extended"
---

Recently I ran into a nasty SCSS surprise. A single line of SCSS code that I inserted into my stylesheet bloated the output by almost 3x, taking it from 126kb to 379kb. Needless to say I was a bit shocked. A quick investigation showed my naive use of `@extend` was at fault.

I've created this isolated example to demonstrate the issue. Let's say I need to style the following html blocks. This is very similar to a grid + column structure where we can have up to 12 children which need to evenly lay across the horizontal space.

```html
<!-- simple case -->
<div class="item">...</div>

<!-- nested items in a 3-up column structure -->
<div class="item item--block item--block--3">
  <div class="item">...</div>
  <div class="item">...</div>
  <div class="item">...</div>
</div>

<!-- nested items in a 12-up column structure -->
<div class="item item--block item--block--12">
  <div class="item">...</div>
  <div class="item">...</div>
  <!-- ... more items here ... -->
  <div class="item">...</div>
</div>
```

## The Challenge

I don't want to specify the class as `item item--block item--block--3` *every* time I create a 3-up layout. I'd like to simply use `item--block--3` and have it include the styles of `item` and `item--block`.

So I wrote the following, naively extending `.item` ([view in sassmeister](http://sassmeister.com/gist/d2f51822bd73f173c161))

```scss
@mixin item-generator ($n, $i: 1) {
  @while $i <= $n {
    .item--block--#{$i} {
      @extend .item;
      .item {
        width: (100% / $i);
      }
    }
    $i: $i + 1;
  }
}

.item {
  padding: 12px;
  & + .item {
    padding-left: 0;
  }
}

.item--block {
  width: 100%;
  display: inline-block;
}

@include item-generator(12);
```

## Expectations

I expected the generated css to look something like this:

```css
.item,
.item--block--1,
.item--block--2,
.item--block--3,
.item--block--4,
.item--block--5,
.item--block--6,
.item--block--7,
.item--block--8,
.item--block--9,
.item--block--10,
.item--block--11,
.item--block--12 {
  padding: 12px;
}

.item + .item {
  padding-left: 0;
}

.item--block {
  width: 100%;
  display: inline-block;
}

.item--block--1 .item {
  width: 100%;
}

.item--block--2 .item {
  width: 50%;
}

<!-- 9 blocks removed for brevity -->

.item--block--12 .item {
  width: 8.33333%;
}
```

## Actual Output

But what I got was this — all matching selectors merged together into this huge undesirable mess:

```css
.item,
.item--block--1,
.item--block--2,
.item--block--3,
.item--block--4,
.item--block--5,
.item--block--6,
.item--block--7,
.item--block--8,
.item--block--9,
.item--block--10,
.item--block--11,
.item--block--12 {
  padding: 12px;
}
.item + .item,
.item--block--1 + .item,
.item--block--2 + .item,
.item--block--3 + .item,
.item--block--4 + .item,
.item--block--5 + .item,
.item--block--6 + .item,
.item--block--7 + .item,
.item--block--8 + .item,
.item--block--9 + .item,
.item--block--10 + .item,
.item--block--11 + .item,
.item--block--12 + .item,
.item + .item--block--1,
.item--block--1 + .item--block--1,
.item--block--2 + .item--block--1,
.item--block--3 + .item--block--1,
.item--block--4 + .item--block--1,
.item--block--5 + .item--block--1,
.item--block--6 + .item--block--1,
.item--block--7 + .item--block--1,
.item--block--8 + .item--block--1,
.item--block--9 + .item--block--1,
.item--block--10 + .item--block--1,
.item--block--11 + .item--block--1,
.item--block--12 + .item--block--1,
.item + .item--block--2,
.item--block--1 + .item--block--2,
.item--block--2 + .item--block--2,
.item--block--3 + .item--block--2,
.item--block--4 + .item--block--2,
.item--block--5 + .item--block--2,
.item--block--6 + .item--block--2,
.item--block--7 + .item--block--2,
.item--block--8 + .item--block--2,
.item--block--9 + .item--block--2,
.item--block--10 + .item--block--2,
.item--block--11 + .item--block--2,
.item--block--12 + .item--block--2,
.item + .item--block--3,
.item--block--1 + .item--block--3,
.item--block--2 + .item--block--3,
.item--block--3 + .item--block--3,
.item--block--4 + .item--block--3,
.item--block--5 + .item--block--3,
.item--block--6 + .item--block--3,
.item--block--7 + .item--block--3,
.item--block--8 + .item--block--3,
.item--block--9 + .item--block--3,
.item--block--10 + .item--block--3,
.item--block--11 + .item--block--3,
.item--block--12 + .item--block--3,
.item + .item--block--4,
.item--block--1 + .item--block--4,
.item--block--2 + .item--block--4,
.item--block--3 + .item--block--4,
.item--block--4 + .item--block--4,
.item--block--5 + .item--block--4,
.item--block--6 + .item--block--4,
.item--block--7 + .item--block--4,
.item--block--8 + .item--block--4,
.item--block--9 + .item--block--4,
.item--block--10 + .item--block--4,
.item--block--11 + .item--block--4,
.item--block--12 + .item--block--4,
.item + .item--block--5,
.item--block--1 + .item--block--5,
.item--block--2 + .item--block--5,
.item--block--3 + .item--block--5,
.item--block--4 + .item--block--5,
.item--block--5 + .item--block--5,
.item--block--6 + .item--block--5,
.item--block--7 + .item--block--5,
.item--block--8 + .item--block--5,
.item--block--9 + .item--block--5,
.item--block--10 + .item--block--5,
.item--block--11 + .item--block--5,
.item--block--12 + .item--block--5,
.item + .item--block--6,
.item--block--1 + .item--block--6,
.item--block--2 + .item--block--6,
.item--block--3 + .item--block--6,
.item--block--4 + .item--block--6,
.item--block--5 + .item--block--6,
.item--block--6 + .item--block--6,
.item--block--7 + .item--block--6,
.item--block--8 + .item--block--6,
.item--block--9 + .item--block--6,
.item--block--10 + .item--block--6,
.item--block--11 + .item--block--6,
.item--block--12 + .item--block--6,
.item + .item--block--7,
.item--block--1 + .item--block--7,
.item--block--2 + .item--block--7,
.item--block--3 + .item--block--7,
.item--block--4 + .item--block--7,
.item--block--5 + .item--block--7,
.item--block--6 + .item--block--7,
.item--block--7 + .item--block--7,
.item--block--8 + .item--block--7,
.item--block--9 + .item--block--7,
.item--block--10 + .item--block--7,
.item--block--11 + .item--block--7,
.item--block--12 + .item--block--7,
.item + .item--block--8,
.item--block--1 + .item--block--8,
.item--block--2 + .item--block--8,
.item--block--3 + .item--block--8,
.item--block--4 + .item--block--8,
.item--block--5 + .item--block--8,
.item--block--6 + .item--block--8,
.item--block--7 + .item--block--8,
.item--block--8 + .item--block--8,
.item--block--9 + .item--block--8,
.item--block--10 + .item--block--8,
.item--block--11 + .item--block--8,
.item--block--12 + .item--block--8,
.item + .item--block--9,
.item--block--1 + .item--block--9,
.item--block--2 + .item--block--9,
.item--block--3 + .item--block--9,
.item--block--4 + .item--block--9,
.item--block--5 + .item--block--9,
.item--block--6 + .item--block--9,
.item--block--7 + .item--block--9,
.item--block--8 + .item--block--9,
.item--block--9 + .item--block--9,
.item--block--10 + .item--block--9,
.item--block--11 + .item--block--9,
.item--block--12 + .item--block--9,
.item + .item--block--10,
.item--block--1 + .item--block--10,
.item--block--2 + .item--block--10,
.item--block--3 + .item--block--10,
.item--block--4 + .item--block--10,
.item--block--5 + .item--block--10,
.item--block--6 + .item--block--10,
.item--block--7 + .item--block--10,
.item--block--8 + .item--block--10,
.item--block--9 + .item--block--10,
.item--block--10 + .item--block--10,
.item--block--11 + .item--block--10,
.item--block--12 + .item--block--10,
.item + .item--block--11,
.item--block--1 + .item--block--11,
.item--block--2 + .item--block--11,
.item--block--3 + .item--block--11,
.item--block--4 + .item--block--11,
.item--block--5 + .item--block--11,
.item--block--6 + .item--block--11,
.item--block--7 + .item--block--11,
.item--block--8 + .item--block--11,
.item--block--9 + .item--block--11,
.item--block--10 + .item--block--11,
.item--block--11 + .item--block--11,
.item--block--12 + .item--block--11,
.item + .item--block--12,
.item--block--1 + .item--block--12,
.item--block--2 + .item--block--12,
.item--block--3 + .item--block--12,
.item--block--4 + .item--block--12,
.item--block--5 + .item--block--12,
.item--block--6 + .item--block--12,
.item--block--7 + .item--block--12,
.item--block--8 + .item--block--12,
.item--block--9 + .item--block--12,
.item--block--10 + .item--block--12,
.item--block--11 + .item--block--12,
.item--block--12 + .item--block--12 {
  padding-left: 0;
}

.item--block {
  width: 100%;
  display: inline-block;
}

.item--block--1 .item,
.item--block--1 .item--block--1,
.item--block--1 .item--block--2,
.item--block--1 .item--block--3,
.item--block--1 .item--block--4,
.item--block--1 .item--block--5,
.item--block--1 .item--block--6,
.item--block--1 .item--block--7,
.item--block--1 .item--block--8,
.item--block--1 .item--block--9,
.item--block--1 .item--block--10,
.item--block--1 .item--block--11,
.item--block--1 .item--block--12 {
  width: 100%;
}

.item--block--2 .item,
.item--block--2 .item--block--1,
.item--block--2 .item--block--2,
.item--block--2 .item--block--3,
.item--block--2 .item--block--4,
.item--block--2 .item--block--5,
.item--block--2 .item--block--6,
.item--block--2 .item--block--7,
.item--block--2 .item--block--8,
.item--block--2 .item--block--9,
.item--block--2 .item--block--10,
.item--block--2 .item--block--11,
.item--block--2 .item--block--12 {
  width: 50%;
}

<!-- 9 blocks removed for brevity -->

.item--block--12 .item,
.item--block--12 .item--block--1,
.item--block--12 .item--block--2,
.item--block--12 .item--block--3,
.item--block--12 .item--block--4,
.item--block--12 .item--block--5,
.item--block--12 .item--block--6,
.item--block--12 .item--block--7,
.item--block--12 .item--block--8,
.item--block--12 .item--block--9,
.item--block--12 .item--block--10,
.item--block--12 .item--block--11,
.item--block--12 .item--block--12 {
  width: 8.33333%;
}
```

**Woah!** Not ideal.

What I had not anticipated was having `@extend .item;` match against `.item` **and** `.item + .item` **and** `.item--block--# .item`, effectively merging all of the selectors together.

## Solution

While I did not expect it to match against every occurance of `.item` within my stylesheet I now see the behavior is expected. It's called [merging selector sequences](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#merging_selector_sequences).

If this merging is not desired then the solution is quite simple — don't use `@extend` with real selectors. Use [placeholder `%` selectors](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#placeholders) instead.

Here is the fixed code rendering css as expected ([view is sassmeister](http://sassmeister.com/gist/5ea1df3c7ea4f39a2019)) thanks to scss placeholder selectors:

```scss
@mixin item-generator ($n, $i: 1) {
  @while $i <= $n {
    .item--block--#{$i} {
      @extend %item;
      .item {
        width: (100% / $i);
      }
    }
    $i: $i + 1;
  }
}

%item {
  padding: 12px;
}

.item {
  @extend %item;
  & + .item {
    padding-left: 0;
  }
}

.item--block {
  width: 100%;
  display: inline-block;
}

@include item-generator(12);
```

## Postscript

I just want to note that the above code is not *real* scss from a project — I only created it to demonstrate the selector merging vs placeholder selector behavior. Please don't take this as a suggestion of how to write great scss.

> Originally posted at [codepen](http://codepen.io/somethingkindawierd/post/scss-unexpected-extend-matching)
