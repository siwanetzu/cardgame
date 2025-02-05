extends Node2D  # Root must be Node2D for positioning

@onready var deck = $Deck  # Reference to deck system
@onready var card_container = $CardContainer  # Where drawn cards are displayed

@export var card_scene: PackedScene  # Assign Card.tscn in the Inspector

var selected_cards = []

func _ready():
	draw_hand(5)  # Draw 5 cards when the game starts

func draw_hand(count):
	# Clear any existing cards
	for child in card_container.get_children():
		child.queue_free()
	selected_cards.clear()
	
	# Draw new cards
	for i in range(count):
		var card_data = deck.draw_card()
		if card_data:
			var new_card = card_scene.instantiate()
			new_card.rank = card_data.rank
			new_card.suit = card_data.suit
			card_container.add_child(new_card)
			# Connect the selection signal
			new_card.selection_changed.connect(_on_card_selection_changed)
			print("Spawned card:", card_data.rank, card_data.suit)

func _on_card_selection_changed(card, is_selected):
	if is_selected:
		if not card in selected_cards:
			selected_cards.append(card)
	else:
		selected_cards.erase(card)
	
	print("Selected cards:", get_selected_cards_string())
	
	# Here you can add logic to evaluate poker hands when cards are selected
	if selected_cards.size() == 5:
		evaluate_hand()

func get_selected_cards_string() -> String:
	var cards = []
	for card in selected_cards:
		cards.append(card.rank + card.suit)
	return ", ".join(cards)

func evaluate_hand():
	# TODO: Implement poker hand evaluation
	print("Evaluating hand with cards:", get_selected_cards_string())

# Add a button to redraw the hand
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Space bar
		draw_hand(5)  # Redraw 5 cards
