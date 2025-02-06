extends Node2D  # Root must be Node2D for positioning

@onready var deck = $Deck  # Reference to deck system
@onready var card_container = $CardContainer  # Where drawn cards are displayed
@onready var hand_label = $HandDisplay/MarginContainer/VBoxContainer/HandLabel
@onready var score_label = $HandDisplay/MarginContainer/VBoxContainer/ScoreLabel
@onready var hand_display = $HandDisplay
@onready var submit_button = $ButtonContainer/SubmitButton
@onready var new_game_button = $ButtonContainer/NewGameButton
@onready var total_score_label = $GameInfo/MarginContainer/VBoxContainer/ScoreLabel
@onready var round_label = $GameInfo/MarginContainer/VBoxContainer/RoundLabel
@onready var target_label = $GameInfo/MarginContainer/VBoxContainer/TargetLabel
@onready var hands_label = $GameInfo/MarginContainer/VBoxContainer/HandsLabel
@onready var redraws_label = $GameInfo/MarginContainer/VBoxContainer/RedrawsLabel
@onready var game_manager = $GameManager

@export var card_scene: PackedScene  # Assign Card.tscn in the Inspector

var selected_cards = []
var hand_evaluator = HandEvaluator.new()
var current_score = 0

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
	# Connect signals
	game_manager.chips_updated.connect(_on_score_updated)
	game_manager.round_updated.connect(_on_round_updated)
	game_manager.redraws_updated.connect(_on_redraws_updated)
	game_manager.hands_updated.connect(_on_hands_updated)
	game_manager.round_completed.connect(_on_round_completed)
	game_manager.game_over.connect(_on_game_over)
	submit_button.pressed.connect(_on_submit_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	
	start_new_game()

func start_new_game():
	game_manager.reset_game()
	deck.shuffle_deck()
	draw_hand(5)
	update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))
	update_score_display(0)
	submit_button.disabled = false
	new_game_button.disabled = false

func draw_hand(count):
	if not game_manager.redraw_hand():
		# Can't redraw - either out of redraws or hands
		if game_manager.is_game_over():
			show_game_over()
		return
		
	# Clear any existing cards
	for child in card_container.get_children():
		child.queue_free()
	selected_cards.clear()
	current_score = 0
	update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))
	update_score_display(0)
	
	# Draw new cards
	for i in range(count):
		var card_data = deck.draw_card()
		if card_data:
			var new_card = card_scene.instantiate()
			new_card.rank = card_data.rank
			new_card.suit = card_data.suit
			card_container.add_child(new_card)
			new_card.selection_changed.connect(_on_card_selection_changed)

func _on_card_selection_changed(card, is_selected):
	if is_selected:
		if not card in selected_cards:
			selected_cards.append(card)
	else:
		selected_cards.erase(card)
	
	if selected_cards.size() > 0:
		evaluate_hand()
		submit_button.disabled = false
	else:
		update_hand_display("Select cards to form a hand", Color(1, 1, 1, 1))
		update_score_display(0)
		submit_button.disabled = true

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
	
	# Calculate base score
	current_score = hand_evaluator.calculate_score(result)
	
	# Apply Joker modifiers (to be implemented)
	current_score = apply_joker_modifiers(current_score, result)
	
	# Update the display with the result
	update_hand_display(message, HAND_COLORS[result.rank])
	update_score_display(current_score)
	
	# Animate the display
	var tween = create_tween()
	tween.tween_property(hand_display, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(hand_display, "scale", Vector2(1.0, 1.0), 0.1)

func apply_joker_modifiers(base_score: int, hand_result: Dictionary) -> int:
	var final_score = base_score
	# TODO: Apply modifiers from active_jokers
	# This will be implemented when we add Jokers
	return final_score

func update_hand_display(text: String, color: Color):
	hand_label.text = text
	hand_label.add_theme_color_override("font_color", color)

func update_score_display(score: int):
	if score == 0:
		score_label.text = ""
	else:
		score_label.text = "Score: %d" % score
		# TODO: Add display for active Joker modifiers

func _on_score_updated(amount: int):
	total_score_label.text = "Total Score: %d" % amount

func _on_round_updated(round_num: int, target: int):
	round_label.text = "Round %d" % round_num
	target_label.text = "Target: %d" % target

func _on_redraws_updated(remaining: int):
	redraws_label.text = "Redraws: %d" % remaining

func _on_hands_updated(remaining: int):
	hands_label.text = "Hands Left: %d" % remaining

func _on_round_completed(success: bool, score: int):
	if success:
		update_hand_display("Round Complete! +" + str(score) + " points", Color(0, 1, 0, 1))
		draw_hand(5)  # Automatically draw new hand for next round
	else:
		update_hand_display("Keep trying! Need " + str(game_manager.round_target) + " to advance", Color(1, 1, 0, 1))

func _on_game_over(total_score: int, round_reached: int):
	var message = "Game Over!\nTotal Score: %d - Reached Round %d" % [total_score, round_reached]
	update_hand_display(message, Color(1, 0, 0, 1))
	submit_button.disabled = true
	new_game_button.disabled = false

func _on_submit_pressed():
	game_manager.submit_hand(current_score)
	submit_button.disabled = true
	
	# Get the indices of selected cards to maintain position
	var selected_indices = []
	var all_cards = card_container.get_children()
	for card in selected_cards:
		selected_indices.append(all_cards.find(card))
	selected_indices.sort()  # Sort to process from left to right
	
	# Remove only the selected cards
	for card in selected_cards:
		card.queue_free()
	
	# Draw new cards in the same positions
	for idx in selected_indices:
		var card_data = deck.draw_card()
		if card_data:
			var new_card = card_scene.instantiate()
			new_card.rank = card_data.rank
			new_card.suit = card_data.suit
			card_container.add_child(new_card)
			card_container.move_child(new_card, idx)  # Move to original position
			new_card.selection_changed.connect(_on_card_selection_changed)
	
	selected_cards.clear()
	current_score = 0
	update_score_display(0)

func _on_new_game_pressed():
	start_new_game()

# Space bar now only works if we can redraw
func _input(event):
	if event.is_action_pressed("ui_accept"):
		draw_hand(5)

func show_game_over():
	update_hand_display("Game Over! Final Score: " + str(game_manager.current_chips), Color(1, 0, 0, 1))
	submit_button.disabled = true
