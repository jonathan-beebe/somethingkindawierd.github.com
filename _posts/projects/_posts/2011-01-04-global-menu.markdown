---
layout: project
title: Global Menu
category: project
tags: hidden
summary: A globally accessible menu for accessing a company's admin/customer service tools across multiple support domains.
---
Global Menu
===========

This might seem like a small task; indeed it was. Why include it in my portfolio? I had to overcome 3 challenges due to the environment(s) it needed to co-exist with.

Problem
-------

The company needed a globally accessible menu for accessing all its admin/customer service tools. This was challenging, and the solution unique, for these reasons:

1.	The menu had to co-exist with *alot* of old (as in 10+ years old) projects, each with divergent css styles, javascript libraries, frameworks, etc. This menu was required to display on top of these old projects without interference.
2.	Because of #1 it had to co-exist with pages containing no js libraries and pages using multiple js libraries from jQuery to Mootools to homegrown. Thus I could not rely on the existence of a given js library, nor could I load in *another* library on top of what they already had. The menu must work using only vanilla js.
3.	The host sites needing this menu existed across many domains and a few servers. The menu could only be hosted from one of those servers -- the one hosting their antiquated login system. I could not rely on server-side includes to render the menu; it had to load via a client-side javascript request once the host site loaded.

Solution
--------

I include this "simple" project in my portfolio because it's possibly the most generic, reusable code I've ever created. It relies on nothing except a config file defining the menu items. Once complete it was installed across the entire company's backend infrastructure, providing a single entry point for accessing the admin services available to the active use.

Once included, it will render a small quarter-circle in the upper-left corner of the browser:

<div class="img full">
<img src="/images/projects/global-menu/closed-menu.jpg" />
</div>

When hovered over it will expand to show the full menu:

<div class="img full">
<img src="/images/projects/global-menu/expanded-menu.jpg" />
</div>

A single `<script>` include enables the global menu:

{% highlight html %}
<script type="text/javascript" src="http://domain.com/backend_urls/menu.php"></script>
{% endhighlight %}

If the host site had strange behavior for any reason, such as a css namespace collision, the menu allowed for customization of the css/javascript namespace via a url parameter:

{% highlight html %}
<script type="text/javascript" src="http://domain.com/backend_urls/menu.php?ns=custom_namespace"></script>
{% endhighlight %}

Including this file downloads a customized javascript file, which in turn renders the customized css stylestheet & the customized menu's HTML.

Features
--------

*	Customizable namespace for css and javascript.
*	Vanilla js implementation entirely protected within closure. No reliance on, or collision with, external code.
*	Accessible only to logged-in users. Able to customize menu contents based on user's access level.
*	Include entire project via one `<script>` tag

Thanks
------

Many thanks to:

*	[Stackoverflow](http://stackoverflow.com/questions/tagged/javascript). I never knew how much vanilla js I *didn't* know until I had to rely on it.
*	[John Resig's Flexible Javascript Events](http://ejohn.org/projects/flexible-javascript-events/) which allowed for super clean event handling across the browser landscape without the need for an extended library.
