extends Node  # Ensure this is a non-visual node

var suits = ["♠", "♥", "♦", "♣"]
var ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
var deck = []

func _ready():
	generate_deck()
	shuffle_deck()

func generate_deck():
	deck.clear()
	for suit in suits:
		for rank in ranks:
			deck.append({ "rank": rank, "suit": suit })

func shuffle_deck():
	deck.shuffle()

func draw_card():
	if deck.size() > 0:
		return deck.pop_front()  # Draw the top card
	return null
