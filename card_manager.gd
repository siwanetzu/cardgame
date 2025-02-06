extends Node2D  # Root must be Node2D for positioning

@onready var deck = $Deck  # Reference to deck system
@onready var card_container = $CardContainer  # Where drawn cards are displayed
@onready var hand_label = $HandDisplay/MarginContainer/HandLabel
@onready var hand_display = $HandDisplay

@export var card_scene: PackedScene  # Assign Card.tscn in the Inspector

var selected_cards = []
var hand_evaluator = HandEvaluator.new()

# Colors for different hand ranks
const HAND_COLORS = {
	HandEvaluator.HandRank.ROYAL_FLUSH: Color(1, 0.84, 0, 1),      # Gold
	HandEvaluator.HandRank.STRAIGHT_FLUSH: Color(0.85, 0.65, 0.8, 1),  # Pink
	HandEvaluator.HandRank.FOUR_OF_A_KIND: Color(0.6, 0.8, 1, 1),   # Light Blue
	HandEvaluator.HandRank.FULL_HOUSE: Color(0.8, 0.6, 1, 1),     # Purple
	HandEvaluator.HandRank.FLUSH: Color(0.6, 1, 0.6, 1),          # Light Green
	HandEvaluator.HandRank.STRAIGHT: Color(1, 0.8, 0.4, 1),       # Light Orange
	HandEvaluator.HandRank.THREE_OF_A_KIND: Color(1, 0.6, 0.6, 1), # Light Red
	HandEvaluator.HandRank.TWO_PAIR: Color(0.8, 0.8, 1, 1),       # Light Purple
	HandEvaluator.HandRank.PAIR: Color(0.9, 0.9, 0.9, 1),         # Light Grey
	HandEvaluator.HandRank.HIGH_CARD: Color(1, 1, 1, 1),          # White
}

func _ready():
	draw_hand(5)  # Draw 5 cards when the game starts
	update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))

func draw_hand(count):
	# Clear any existing cards
	for child in card_container.get_children():
		child.queue_free()
	selected_cards.clear()
	update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))
	
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
	
	if selected_cards.size() > 0:
		evaluate_hand()
	else:
		update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))

func get_selected_cards_string() -> String:
	var cards = []
	for card in selected_cards:
		cards.append(card.rank + card.suit)
	return ", ".join(cards)

func evaluate_hand():
	var result = hand_evaluator.evaluate_hand(selected_cards)
	var message = result.name
	
	# Add additional details based on the hand type
	match result.rank:
		HandEvaluator.HandRank.ROYAL_FLUSH:
			message += " of " + result.suit
		HandEvaluator.HandRank.STRAIGHT_FLUSH:
			message += " (" + result.high_card + " high) of " + result.suit
		HandEvaluator.HandRank.FOUR_OF_A_KIND:
			message += " (" + result.value + "s)"
		HandEvaluator.HandRank.FULL_HOUSE:
			message += " (" + result.three_rank + "s over " + result.pair_rank + "s)"
		HandEvaluator.HandRank.FLUSH:
			message += " of " + result.suit
		HandEvaluator.HandRank.STRAIGHT:
			message += " (" + result.high_card + " high)"
		HandEvaluator.HandRank.THREE_OF_A_KIND:
			message += " (" + result.value + "s)"
		HandEvaluator.HandRank.TWO_PAIR:
			message += " (" + result.high_pair + "s and " + result.low_pair + "s)"
		HandEvaluator.HandRank.PAIR:
			message += " of " + result.value + "s"
		HandEvaluator.HandRank.HIGH_CARD:
			message += " (" + result.high_card + ")"
	
	# Add number of cards used
	message += " (%d cards)" % selected_cards.size()
	
	# Update the display with the result
	update_hand_display(message, HAND_COLORS[result.rank])
	
	# Animate the display
	var tween = create_tween()
	tween.tween_property(hand_display, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(hand_display, "scale", Vector2(1.0, 1.0), 0.1)

func update_hand_display(text: String, color: Color):
	hand_label.text = text
	hand_label.add_theme_color_override("font_color", color)

# Add a button to redraw the hand
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Space bar
		draw_hand(5)  # Redraw 5 cards
