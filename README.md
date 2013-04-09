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

 * [LDoc](https://github.com/stevedonovan/LDoc) by (stevedonovan)[https://github.com/stevedonovan]
 * bash, iwatch, lua 5.1

Games
-----

Games known to be using Frost:

 * (Lord Evil's Daring Escape)[https://github.com/cryovat/lord-evil-game]

Work environment
----------------

The following shell commands should clone the frost repo, pull down
dependencies and configure a proper development environment. The script assumes
an Unix-like environment.

    git clone https://github.com/cryovat/frost
    cd frost
    ./configure.sh

To monitor source directory and regenerate documentation upon source
file changes (requires iwatch and lua 5.1):

    ./docmon.sh
