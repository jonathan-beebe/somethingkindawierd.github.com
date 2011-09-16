---
layout: project
title: Game Layer
category: project
tags: test
---
The Game Layer
==============

The past decade defined the social layer of the internet. This decade will [define
the game layer](game-layer).

SoShopping
==========

SoShopping was my foray into the game layer.

The design goal of the client: create a shopping site, leveraging some of their patented ideas, 
engaging users in the site via game metaphors.

We created an ecommerce system with an integrated game layer. Users don't simply shop;
they play the game to earn rewards. The game is part of the shopping experience.

The game layer is built on top of the social internet. SoShopping relies heavily
on Facebook and Twitter's apis, allowing users to communicate with friends and share
their success.

What makes SoShopping Unique?
-----------------------------

The framework we devoloped utilizes [APE](ape) to keep a live connection to each
user's browser. This allowed us to push information to users, responding to game
events in real-time, creating a rich interactivity not seen in most sites.

To keep the site responsive we created a server-side event system capable of 
spinning off forked php processes. The thread rendering the response could return
immediately. The forked process does it's work  independently of the parent process.
When it completes, since APE allowed us to push responses back to the user's browser,
we were able to render ...

[game-layer]: http://www.ted.com/talks/seth_priebatsch_the_game_layer_on_top_of_the_world.html
[ape]: http://www.ape.org
