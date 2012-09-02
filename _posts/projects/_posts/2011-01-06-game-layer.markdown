---
layout: project
title: The Game Layer
category: project
tags: hidden
summary: My foray into the game layer of the *net
---
The Game Layer
==============

The past decade defined the social layer of the internet.

This decade will [define the game layer](http://www.ted.com/talks/seth_priebatsch_the_game_layer_on_top_of_the_world.html) (*or so they say*.)

SoShopping was my foray into the game layer.

SoShopping
----------

SoShopping, and the framework we created, were designed to progress e-commerce beyond the static search & buy experience. We integrated game-dynamics into the site, influencing what users do and how they do it.

Users don't simply shop; they play the game.

<div class="img full">
<img src="/images/projects/game-layer/soshopping-user-profile.jpg" />
</div>

### What makes SoShopping Unique?

The framework we developed utilizes [APE](http://www.ape.org) to keep a live connection to each
user's browser. This allowed us to *push* information to users, responding to game
events in *real-time*, resulting in rich interactivity not seen in most sites. APE literally opens a channel to more deeply engage the customer.

To keep the site responsive we created a [server-side event system capable of
spinning off forked php processes](https://github.com/somethingkindawierd/somethingkindawierd.github.com/wiki/Detached-PHP-Events). The thread initiating the action could return immediately, keeping the browsing exerience fast. The forked process completes its work independently of the parent process. When completed, APE pushes the response to the user(s).

The result is an interactive experience with immersive action/response mechanisms, engaging the users attention and keeping it.

The screenshot shown below demonstrates a pushed message. Based on the user's action of lowering the price a message has been pushed to their browser in response. Similar messages might have been pushed to others within the users circle of friends, or to users who've already expressed interest in the product.

<div class="img full">
<img src="/images/projects/game-layer/soshopping-price-drop.jpg" />
</div>

At all times a user (player) can track achievements and rewards, learn about their next goals, and get clues about hidden features to be unlocked at later stages in the game.

<div class="img full">
<img src="/images/projects/game-layer/soshopping-achievements.jpg" />
</div>

And, of course, we had the ubiquitous leaderboard. As this screenshot illustrates, we leveraged the social-layer, allowing users to connect, form teams, and enhance the energy built within the game.

<div class="img full">
<img src="/images/projects/game-layer/soshopping-leaderboard.jpg" />
</div>

Sadly, the company supporting So Shopping ceased operations of the site.
This is all I have left to show of it :(
