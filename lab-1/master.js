
/* MASTER JAVASCRIPT FILE */

/*Card class, these are created in the Deck class's create deck function*/
class Card { 
    constructor(shape, color, number, shading, cardID) {
        this.shape = shape;
        this.color = color;
        this.number = number;
        this.shading = shading;
		this.cardID = cardID;
    }
    /*creates string with appropriate information*/
    toString() {
        return `Shape: ${this.shape}, Color: ${this.color}, Number: ${this.number}, Shading: ${this.shading}`;
    }
  }
  
/*
	Constructor: Creates a deck, initially unshuffled
    Additional functions:
	shuffleDeck(): randomizes the order of cards in the deck
	drawCards(number): returns an array of length number containing the randomnized cards
*/
  class Deck {
    constructor() {
        this.deck = this.createDeck();
    }
    /*creates the cards and deck*/
    createDeck(){
        /*declare card elements*/
        const shapes = ["oval", "diamond", "squiggle"];
        const colors = ["red", "blue", "green"];
        const numbers = ["one", "two", "three"];
        const shadings = ["open", "striped", "solid"];
    
        let deck = [];
		var cardID = -1;
    
        /*create a deck of cards where each card is a Card object*/
        for (let shape of shapes) {
            for (let color of colors) {
                for (let number of numbers) {
                    for (let shading of shadings) {
                        cardID++;
						let card = new Card(shape, color, number, shading, cardID);
                        deck.push(card);
                    }
                }
            }
        }
        return deck;
    }
    /*shuffle the cards by swapping current card with random card*/
    shuffleDeck(){
        for (let i = this.deck.length - 1; i > 0; i--) {
            let j = Math.floor(Math.random() * i);
            let temp = this.deck[i];
            this.deck[i] = this.deck[j];
            this.deck[j] = temp;
        }
    }
    /*draws cards by iterating through a specified number of cards, adding them to a return array and removing them from the deck*/
    drawCards(number){
      let drawnCards = []
      for (let i = 0; i < number; i++) {
        if (this.deck.length>0){
          drawnCards[drawnCards.length]=this.deck.shift();
        }
        else{
          return null;
        }
      }
      return drawnCards;
    }
  }
  
//Initialization Code

var shuffledDeck;
var referenceDeck = [];
var drawnCards;
// This array keeps track of currently selected cards.
var selectedCards = [];
var notificationBox = document.getElementById("notification");

var setCheckButton = document.getElementById("setcheck");
var cardsInDeck = document.getElementById("cards_in_deck");

var seconds = 0;
var timerVariable;

var addButton = document.getElementById("addCards");



var startButtons = document.getElementById("start_buttons");
var startButtonParent = startButtons.parentNode;
var spButton = document.getElementById("sp_button");
var mpButton = document.getElementById("mp_button");

var multiplayer;

spButton.addEventListener("click", beginInitializationSp, false);
mpButton.addEventListener("click", beginInitializationMp, false);

function beginInitializationSp() {
	multiplayer = 0;
	sharedInitialization();
}

function beginInitializationMp() {
	multiplayer = 1;
	sharedInitialization();	
}



/* ----------SHARED INITIALIZATION---------- */

/*
	Generates a new deck of cards, preshuffled. Deck object contains an array of cards - that array gets copied into a reference array. The original deck/array is then properly shuffled. Deals out the first 12 cards from that shuffled deck for initial display on the webpage.
*/


function sharedInitialization() {
	
	//Remove selection buttons and erase notification box.
	startButtonParent.removeChild(startButtons);
	notificationBox.innerHTML = "";
	
	shuffledDeck = new Deck();
	for (i = 0; i < shuffledDeck.deck.length; i++) {
		referenceDeck[i] = shuffledDeck.deck[i];
	}
	shuffledDeck.shuffleDeck();
	drawnCards = shuffledDeck.drawCards(12);
	tableGenerate(drawnCards);

	/*
		Apply functionality to the "check set" button
		Initialize and keep track of deck's card count
	*/

	setCheckButton.addEventListener("click", selectedLengthChecker, false);
	cardsInDeck.innerHTML = "Cards in deck: " + shuffledDeck.deck.length;

	addButton.addEventListener("click", addCards, false);

	if (multiplayer) {
		multiplayerInitialization();
	}
	else {
		singleplayerInitialization();
	}
	
	//Begin counting the timer
	timerVariable = setInterval(countUpTimer, 1000)
}

var singleplayerScoreValue = 0;
var singleplayerScoreContainer;
var numberOfPlayers;
/* playerSelectionForm is already a form tag initially in the HTML file */
var playerSelectionForm = document.getElementById("player_list");
/* playerScoreList is already a div tag in the HTML file */
var playerScoreList = document.getElementById("score_list");


/* ----------SINGLEPLAYER AND MULTIPLAYER INITIALIZATION---------- */

function singleplayerInitialization() {
	numberOfPlayers = 1;
	singleplayerScoreContainer = document.getElementById("singleplayer_score");
	singleplayerScoreContainer.innerHTML = "Score: 0";
}

function multiplayerInitialization() {
	
	numberOfPlayers = 2;
	/* Dynamically populate form based on number of players */
	for (let i = 1; i <= numberOfPlayers; i++) {
		
		/* Radio buttons for form */
		let playerButton = document.createElement("input");
		playerButton.setAttribute("type", "radio");
		playerButton.setAttribute("id", "p" + i.toString());
		playerButton.setAttribute("name", "selection");
		playerButton.setAttribute("player_number", i.toString());
		
		/* Labels to accompany radio buttons */
		let playerLabel = document.createElement("label");
		playerLabel.setAttribute("for", "p" + i.toString());
		playerLabel.innerHTML = "Player " + i.toString();
		
		/* Line break to separate player list */
		let lineBreak = document.createElement("br");
		
		/* Append these tags to the form, in order, for each player */
		playerSelectionForm.appendChild(playerButton);
		playerSelectionForm.appendChild(playerLabel);
		playerSelectionForm.appendChild(lineBreak);
	}
	
	//Mark beginning of player list
	playerScoreList.innerHTML = "Score List";
	/* Dynamically populate player score list */
	for (let i = 1; i <= numberOfPlayers; i++) {
		
		let scoreNumber = document.createElement("span");
		scoreNumber.innerHTML = "0";
		let playerScoreIndividual = document.createElement("p");
		playerScoreIndividual.setAttribute("player_score", i.toString());
		playerScoreIndividual.innerHTML = "Player " + i.toString() + ": ";
		
		playerScoreIndividual.appendChild(scoreNumber);
		playerScoreList.appendChild(playerScoreIndividual);
		
	}
}


/* ----------CARD SELECTION FUNCTIONS---------- */

/*
	PRIMARY FUNCTION: The function associated with the event listener defined above. Behavior is different depending on whether the card that just got clicked is unselected (and not over the 3 card limit), or whether the card was already selected (for deselection).
*/
function clickCard() {
	if ((selectedCards.length < 3) && (this.getAttribute("class") == "card unselected")) {
		selectCard.call(this);
	}
	else if (this.getAttribute("class") == "card selected") {
		deselectCard.call(this);
	}
	
	return 1;
}

/*
	SECONDARY FUNCTION: Selecting a card pushes the associated card ID into the selectedCards array.
*/
function selectCard() {
	
	this.setAttribute("class", "card selected");
	let cardID = parseInt(this.getAttribute("cardid"));
	selectedCards.push(cardID);
	
	return 1;
	
}

/*
	SECONDARY FUNCTION: Deselecting a card removes the associated card ID from the selectedCards array.
*/
function deselectCard() {
	
	this.setAttribute("class", "card unselected");
	let cardID = parseInt(this.getAttribute("cardid"));
	let indexToRemove = selectedCards.indexOf(cardID);
	selectedCards.splice(indexToRemove, 1);
	
	return 1;
	
}




/* ----------SET CHECKING AND SCORING FUNCTIONS---------- */

/*
	PRIMARY FUNCTION: Takes an array of card IDs (set) and checks if all of the Card objects they correspond to form a proper set.
*/
function isSet(set) {

	let isNumberSet = isSetOneFeature("number", set);
	let isShapeSet = isSetOneFeature("shape", set);
	let isShadingSet = isSetOneFeature("shading", set);
	let isColorSet = isSetOneFeature("color", set);
	
	return (isNumberSet && isShapeSet && isShadingSet && isColorSet);

}

/*
	SECONDARY FUNCTION: Takes an array of card IDs (set), relates them back to the Card objects they correspond to in the reference deck array (global variable), and checks to see if one specified (feature) for those Card objects forms a proper set. feature is of type String, set is an array of Card ID numbers that should have a length of 3.
	
	set indices correspond to actual indices in the reference deck.
*/
function isSetOneFeature(feature, set) {
	
	let compare12 = featureCheckTwo(feature, referenceDeck[set[0]], referenceDeck[set[1]]);
	let compare13 = featureCheckTwo(feature, referenceDeck[set[0]], referenceDeck[set[2]]);
	let compare23 = featureCheckTwo(feature, referenceDeck[set[1]], referenceDeck[set[2]]);
	
	return allSameOrDiff(compare12, compare13, compare23);
	
}

/*
	SECONDARY FUNCTION: Returns true if a certain feature is the same between two cards. feature should be of type string, first and second should be Card objects.
*/
function featureCheckTwo(feature, first, second) {
	
	return first[feature] == second[feature];
	
}

/*
	SECONDARY FUNCTION: Supplementary function to isSetOneFeature. a, b, c should be boolean values that resulted from featureCheckTwo. Returns true if each comparison was equal or if each comparison was different. 
*/
function allSameOrDiff(a, b, c) {
	
	let allSame = (a && b && c);
	let allDifferent = ((!a) && (!b) && (!c));
	
	return (allSame || allDifferent);
	
}


/*
	PRIMARY FUNCTION: Guard function that first checks if three cards were properly selected. Depending on the game mode, checks if the cards make up a set and performs other related functions using either the singleplayer or multiplayer algorithm.
*/
function selectedLengthChecker() {
	if (selectedCards.length == 3) {
		
		if (multiplayer) {
			setSubmissionMultiplayer();
		}
		else {
			setSubmissionSinglePlayer();
		}
	}
}

/* 
	SINGLEPLAYER ONLY: Checks if the three cards selected make up a set. Posts a notification about correctness and if correct, increment the player's score.
*/
function setSubmissionSinglePlayer() {
   
	let possibleSet = isSet(selectedCards);
   
	if (possibleSet) {
		singleplayerScoreValue++;
		singleplayerScoreContainer.innerHTML = "Score: " + singleplayerScoreValue.toString();
		replaceFoundSet();
	}
	postSetInfo(possibleSet);
	
	return 1;
}

/* 
	MULTIPLAYER ONLY: First checks if a player was selected prior to submission, and posts a warning if this was not true. Otherwise, checks if the three cards selected make up a set, and posts a notifcation about correctness. If correct, increment's the selected player's score.
*/
function setSubmissionMultiplayer() {
	
	/*
		Check if set chosen was correct, and if a player in the form was selected
		chosenPlayerButton will be non-null if this is the case.
		This is done by looping over all buttons to see if any of them were selected.
	*/
	let possibleSet = isSet(selectedCards);
	let chosenPlayerButton = null;
	let buttonList = document.getElementById("player_list");
	buttonList = buttonList.children;
	for (let i = 0; i < buttonList.length; i++) {
		let buttonIndividual = buttonList[i];
		if (buttonIndividual.checked == true) {
			chosenPlayerButton = buttonIndividual;
		}
	}
	
	//If no player was checked off, send a warning notification.
	if (chosenPlayerButton == null) {
		notificationBox.innerHTML = "Please select a player first!";
		notificationBox.setAttribute("id", "warning");
		//Make notification last for 10 s
		setTimeout(restoreNotificationBox, 10000);
	}
	else if (!possibleSet) {
		//Post a notification indicating that cards did not make up a set
		postSetInfo(possibleSet);
	}
   
	else if (possibleSet) {
		//Get the player number associated with the button, then find the corresponding player's score in the score section
		//Iterates over list of scores to find the correct player
		let chosenPlayerNumber = chosenPlayerButton.getAttribute("player_number");
		let chosenScoreContainer = null;
		let scoreList = document.getElementById("score_list");
		scoreList = scoreList.children;
		for (let j = 0; j < scoreList.length; j++) {
			let scoreIndividual = scoreList[j];
			
			if (scoreIndividual.getAttribute("player_score") == chosenPlayerNumber) {
				chosenScoreContainer = scoreIndividual.children[0];
			}
		}
		
		//Score is contained in the element's contents. Bring it out, increment, and replace
		let playerScoreValue = parseInt(chosenScoreContainer.innerHTML);
		playerScoreValue++;
		chosenScoreContainer.innerHTML = playerScoreValue;
		
		//Remove matched set from the field and replace with new cards from the deck
		replaceFoundSet();
		//Post a notification indicating that cards correct made up a set
		postSetInfo(possibleSet);
		//Uncheck the player
		chosenPlayerButton.checked = false;
	}
	
	return 1;
}

/*
	SECONDARY FUNCTION: Given that a set was correctly matched, replaces the set-making cards with new cards drawn from the deck, clears the list of selected cards, and updates the number of cards remaining in the deck.
*/
function replaceFoundSet() {
	
	replaceCards(shuffledDeck);
	selectedCards = [];
	cardsInDeck.innerHTML = "Cards in deck: " + shuffledDeck.deck.length;
	
	return 1;
}



/* ----------CARD GENERATION FUNCTIONS---------- */

/*
	PRIMARY FUNCTION: Creates four rows of cards 
    (the printCards function creates three cards for each row iterated over).
*/
function tableGenerate(cards) {
    //The <t> table tag in the HTML page has ID "set-list"
	let tableId = document.getElementById("set-list");
    //Create <tbody>
	let tbody = document.createElement("tbody");
	tbody.id = 'table'
    //Creates a <tr> of cards for every iteration, then adds each <tr> to <tbody>
	for (let i = 0; i < 4; i++) {
        let tr = printRow(cards);
        tbody.appendChild(tr);
    }
    
	//Attach <tbody> to <t>
    tableId.appendChild(tbody);
}

/*
	SECONDARY FUNCTION: Creates a table row of three cards.
*/
function printRow(cards) {

    let tr = document.createElement("tr");
    for (let i = 0; i < 3; i++) {
		//Picking a Card object them creating an HTML image tag from it
		let td = printCard(cards);
		tr.appendChild(td);
    }
    return tr;
    
}

/* 
    SECONDARY FUNCTION: Creates a table cell (td element) for one card
*/
function printCard(cards){
    let card = cards.pop();
    let img = createCardHtml(card);
    //Creates a tablecell
    let td = document.createElement("td");
    //Relevant classes will be placed on the table element
    td.setAttribute("class", "card unselected");
    //Attribute card ID can be used to refer back to the reference array of Cards
    td.setAttribute("cardid", card.cardID.toString());
    //Attach image to table cell, then attach cell to the row
    td.appendChild(img);
	//Make cell responsive to clicks, for card selection
	td.addEventListener("click", clickCard, false);
  
    return td;
}

/*
	SECONDARY FUNCTION: Creates an image HTML tag from a Card object, and links it to its corresponding card image file
*/
function createCardHtml(card) {
    //Card image file names were standardized
    let title = card.color + card.shape + card.number + card.shading
	let imgFileName = "./images/" + title + ".jpg"
    //Create the tag and give it the file name
	let imgTag = document.createElement("img");
    imgTag.setAttribute('alt', title)
    imgTag.src = imgFileName;
    return imgTag;
}

/*
    SECONDARY FUNCTION: Supplements replaceCards. Given that a set was matched, removed matched cards from the HTML page and replace them new cards drawn from the deck.
*/
function replaceCards(cards){
    let elements = document.getElementsByClassName('card selected');
    for (let i = 2; i > -1; i--) {
        element=elements[i]
        element.setAttribute("class", "card unselected");
        element.removeChild(element.firstChild);
		
        //Create new cards only if there are cards remaining in the deck
		if (shuffledDeck.deck.length > 0) {
			let card = cards.drawCards(1).pop();
			let img = createCardHtml(card);
			element.setAttribute("cardid", card.cardID.toString());
			element.appendChild(img);
		}
    }
   return 1;
}


/*
	PRIMARY FUNCTION: Function associated with the event listener for the "Add 3 cards" button. Only if there are enough cards remaining in the deck, add a brand new row of three cards from the deck. Otherwise, warn the player(s) that this operation cannot happen.
*/
function addCards(){
	if (shuffledDeck.deck.length > 0) {
		let tbody = document.getElementById('table')
		let tds = shuffledDeck.drawCards(3);
		let tr = printRow(tds);
		tbody.appendChild(tr);
		//Update number of cards left in deck
		cardsInDeck.innerHTML = "Cards in deck: " + shuffledDeck.deck.length;
	}
	else {
		notificationBox.innerHTML = "Cannot draw any more cards - deck is empty!";
		notificationBox.setAttribute("id", "warning");
		setTimeout(restoreNotificationBox, 10000);
	}
}


/* ----------NOTIFICATION FUNCTIONS---------- */

/*
    PRIMARY FUNCTION: For a group of three cards that were submitted, use the truth value of them forming a set (bool) send a notification to the page indicating whether or not the cards form a set.
*/

function postSetInfo(bool){
    
    if (bool) {
        notificationBox.innerHTML = "Correctly matched a set!";
		notificationBox.setAttribute("id", "success");
    }
    else {
        notificationBox.innerHTML = "Not a set!";
		notificationBox.setAttribute("id", "warning");
    }
    //Message disappears after 10 seconds
    setTimeout(restoreNotificationBox, 10000);
}

/*
	SECONDARY FUNCTION: Accompanies any changes made to the notification box. Returns the box back to a normal, neutral color and removes notification text.
*/
function restoreNotificationBox() {
	notificationBox.innerHTML = "";
	notificationBox.setAttribute("id", "notification");
}


/* 
	PRIMARY FUNCTION: Function for an increasing timer. 
*/
function countUpTimer() {
  ++seconds;
  document.getElementById("count_up_timer").innerHTML = "Game time: " + seconds + " sec";
}



























