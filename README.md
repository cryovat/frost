Frost
=====

Frost is a minimal game framework for [LÖVE 0.8](http://www.love2d.org).
It consists of a collection of Lua scripts that provide the following:

 * Game state management
 * Simple menu framework
 * Tile sheets
 * Sprite animation

The following features are planned:

 * Scripts
 * Cutscenes
 * Simple GUI widgets
 * 2D platformer base
 * 2D "RPG" base

Dependencies
------------

 * [LÖVE 0.8](http://www.love2d.org)

For development aid:

 * [LDoc](https://github.com/stevedonovan/LDoc) by [stevedonovan](https://github.com/stevedonovan)
 * GNU Make, bash, iwatch, lua 5.1

Games
-----

Games known to be using Frost:

 * [Lord Evil's Daring Escape](https://github.com/cryovat/lord-evil-game)

Work environment
----------------

To monitor source directory and regenerate documentation upon source
file changes (requires GNU Make, iwatch and lua 5.1):

    make watch

To run:

    make run

To run in a sanity-preserving manner (without updating all the submodules
every time):

    make fastrun
