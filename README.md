sedbot
======

Sedbot is a KISS irc bot to handle sed-like s/.../.../ corrections and related hijinks.

Features
--------
It's written in awk (needs gawk extensions), and implements the following suffixes:
*   i/I for case-insensitive match
*   decimal integer _n_ (must be >0) to replace only the _n_th match
*   g/G to replace every match

It also implements <http://m.xkcd.com/181/> replacements.

Usage
-----
This bot doesn't actually connect to an IRC server -- it's intended to be used
with [ii](http://tools.suckless.org/ii). Once you have ii running, and have
`/join`ed the channel you want to run the bot in, do something like:

    tail -Fn1 irc/irc.example.org/#channel/out | sedbot.awk outfile=irc/irc.example.org/#channel/in
