---
layout: project
title: BIG Images
category: project
summary: I owned this awesomeness!
tags: test
---
My 1st Foray into business
=========

Circa 2003 &ndash; 2009

BIG Images was my 1st successful attempt at running a brick-and-mortar business. 
Not my 1st business, but the 1st to involve an investor, a retail storefront
with a lease, large up-front capital expenses, etc.

We were young, had *big* dreams, a business plan, and a mission. Our stated
mission was "Revolutionizing large format printing through technology and 
relentless customer service."

We hade some fun innovations back then. My business partner had written a custom
FileMaker Pro database that powered the business through it's entire history. I
learned AppleScript to automate many redundant tasks, always asking the question
"how can I program away the need for an employee here&hellip;" 

Part of the FileMaker system was a quick-quoting tool. We we so efficient we'd 
often have a job quoted, completed, and delivered before our competition had
completed their quote for the same job.

And through it all, we had a dedication to quality, stating "we live, breath, 
and sleep quality. Our business is designed to provide you with services and 
products that will delight and even surpass your expectations."

What did I learn?
=================

Truly, I couldn't tell you everything I learned in an entire book. But I 
include this story here simple to tell you that I learned to program computers 
while owning BIG Images. My tasks involved managing the print hardware, color-calibrating
the equipment, and managing the pre-press workflow (accepting customer's 
graphics files and ensuring they're ready to print.) 

In an effort to live up to our mission of "relentless customer service" I took
it upon myself to automate everything I could. This led to a mastery of AppleScript,
and later some lower-level scripting languages and web development.

Heading 2
---------

### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6


Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi at erat non purus euismod congue nec vitae erat. Nulla arcu neque, porttitor at condimentum non, faucibus et lacus. Nulla eget lorem libero. Donec mauris dui, aliquet sit amet egestas eu, porttitor et nunc. Pellentesque in nisl velit, ac adipiscing nisi. Proin vehicula, eros at viverra molestie, risus arcu molestie sapien, sed dapibus felis massa vitae nunc. Cras dignissim lectus at metus viverra id porttitor sapien feugiat. Sed hendrerit, magna vel sodales hendrerit, ipsum velit convallis purus, vitae gravida mi ligula id dolor. Donec vel ipsum a risus varius convallis. Mauris sit amet leo eu ligula malesuada mattis. Vestibulum eleifend, dui non elementum tincidunt, massa erat ultricies enim, vel tincidunt est ipsum in risus. Curabitur laoreet sapien vitae mauris rutrum ultrices.



{% highlight javascript linenos %}
// A basic to-string method to help us debug our objects.
// using `console.log(obj)` with an object literal will not guarentee an
// accurate representation of that object at that instant. Thus we render
// it to a string to get an accurate snapshot.
Object.implement({

  toString: function(target) {
	target = target || this;
	return JSON.encode(this);
  }

});
{% endhighlight %}

<div class="img full">
<img src="/images/full.jpg" />
</div>


Aenean sem lectus, dapibus et gravida ut, interdum ut nunc. Nunc ornare sollicitudin consectetur. In hac habitasse platea dictumst. Praesent consequat erat vitae nisl aliquet auctor. Suspendisse pharetra, tortor at luctus molestie, odio purus vulputate augue, eu pretium justo dui a justo. Pellentesque non lectus at erat mollis consequat quis nec nunc. Aenean fermentum volutpat pharetra. Maecenas ut risus sit amet neque faucibus malesuada. In elementum, justo quis posuere ullamcorper, libero velit hendrerit dui, at malesuada lacus tortor sed massa. Cras quis volutpat ante. Pellentesque et ante nunc, vitae feugiat arcu. Integer eget erat tortor. Praesent fringilla fringilla lobortis.


<div class="img half left">
<img src="/images/half_01.jpg" />
</div>
<div class="img half right">
<img src="/images/half_02.jpg" />
</div>
<div class="img half left">
<img src="/images/half_03.jpg" />
</div>
<div class="img half right">
<img src="/images/half_04.jpg" />
</div>

*	List
*	Items in List
*	More and More
*	Stuff
	*	Here's the nested stuff.
	*	Nested list
	*	More nested
	*	How's it look?
*	More

1.	 Numbered List
1.	 Items in List
1.	 More and More
1.	 Stuff
	1.	 Nested List?
	1.	 Nested Numbered list
	1.	 One
	1.	 Five
1.	 More

