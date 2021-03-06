HackTX-Assassin
===============

Assassin game for iOS, developed at HackTX.

We are using low-energy Bluetooth to obtain accurate location values to make sure you are in range of your target.

Unlike traditional Assassin, we are able to offer several weapon options with different ranges and probabilities of hitting your target.

The three in the initial release are:

Sword- you must be close to your target but will always hit.
Bow- you must be in sight of your target and have a 75% chance of hitting. If you miss, they are notified and you need 2 minutes to reload.
Poison- you must be close to your target to poison them. The poison takes roughly 24 hours to take affect with a 90% effective rate.

Players create and join the game using a game name and password, then all agree to start. The game manages your target for you.

The biggest advantage of this is that there is no human manager required. Now you can play with all of your friends without one of them sitting on the sideline managing the game!

Team members:
Chris Mlinac
Alan Bouzek
Nathan Chapman
Nari Voyles

Check out our proof of concept, test_beacon: https://github.com/abouzek/test_beacon

Progress: Unfortunately, we ran into some problems sending notifications between devices via Bluetooth. There was very little documentation for how to do this, and we felt the next best implementation involving push notifications was too inefficient to implement, so we decided to leave Assassin unfinished until Apple releases more information about the new Bluetooth features in iOS7.
