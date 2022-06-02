# Project 1 - Javascript Game of Set, by Team X6

## Game Instructions

The game of Set involves a deck of 81 cards. Each card has possesses the following four features, each with three variations: a type of shape (diamond, squiggle, oval), the number of a given shape (one, two, three), the color of those shape(s) (red, green, blue), and the shading on those shape(s) (solid, striped, open). 

A set can be made from three cards if, for -each individual feature-, the variation of that feature on all three cards are either the same, or the variations of that feature are all different between each card.

A typical game of Set starts out with a table of 12 cards drawn from the 81-card deck. When a player correctly identifies a set and claims it for themselves, that player earns 1 point. The three cards making up the set they claimed are then removed from the field and from play altogether, and are replaced with 3 news cards from the top of the deck.

While Set can be played with one or more player, our version of Set currently only supports the choice between single (1) player mode, or a 2-player mode.
In a game of Set with more than one player, whichever player acquires the most points by the time all players agree to quit the game is considered the winner.

In our version of Set, upon loading the game for the first time, the user will be prompted to select either singleplayer or 2-player mode by clicking the appropriate button. If intending to play 2-player mode with another player, you are encouraged to decide which player is "Player 1" and which is "Player 2" - these will be the names used to distinguish between the different scores.

In our version of Set, cards are chosen simply by clicking on them, and they will be highlighted. Cards can be deselected by simply clicking them again. Up to three cards can be highlighted in this way. 

Checking a set in our game is done in two different ways, depending on whether 1-player mode is active or if 2-player mode is active.
In 1-player mode, simply clicking the "Check set" button is sufficient.
In 2-player mode, one of the radio buttons on the side of the screen indicating a player intending to check their cards should be selected first, before clicking the "Check set" button.
In either mode, when a set is correctly identified, the cards that made up that set will be automatically removed from play and replaced with new cards from the deck.

In addition, our version of Set also has a feature in the form of the "Draw 3 cards" button. It is available for use at any time (up until the deck runs empty), but the player(s) is encouraged to do this only if they have a difficult time identifying a set from the available cards, or, if in 2-player mode, both players agree that drawing 3 more cards is a good choice of action.

## Installation Instructions
If access to the https://github.com/cse-3901-sharkey/x6/releases webpage is available, please download the source code .zip file from the "Project 1 1.0 Build" release. Extract this .zip file into a directory of choice. Navigate into the x6-1.0\lab-1 directory, and open "index.html" to immediately load and begin playing the game.

