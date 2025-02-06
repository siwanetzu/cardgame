extends Node

class_name GameManager

signal chips_updated(new_amount: int)
signal round_updated(round_num: int, target: int)
signal redraws_updated(remaining: int)
signal round_completed(success: bool, score: int)

var current_chips: int = 1000  # Starting chips
var current_round: int = 1
var redraws_remaining: int = 3  # Redraws per round
var round_target: int = 500    # Initial target score

# Round target increases with each round
const TARGET_INCREASE_FACTOR = 1.5
# Cost in chips to redraw
const REDRAW_COST = 100

func _ready():
	emit_signal("chips_updated", current_chips)
	emit_signal("round_updated", current_round, round_target)
	emit_signal("redraws_updated", redraws_remaining)

func start_new_round():
	current_round += 1
	redraws_remaining = 3
	# Increase target score for next round
	round_target = int(round_target * TARGET_INCREASE_FACTOR)
	
	emit_signal("round_updated", current_round, round_target)
	emit_signal("redraws_updated", redraws_remaining)

func can_redraw() -> bool:
	return redraws_remaining > 0 and current_chips >= REDRAW_COST

func redraw_hand():
	if can_redraw():
		redraws_remaining -= 1
		current_chips -= REDRAW_COST
		emit_signal("redraws_updated", redraws_remaining)
		emit_signal("chips_updated", current_chips)
		return true
	return false

func submit_hand(score: int):
	# Convert score to chips (1:1 for now, can be adjusted)
	var chips_earned = score
	current_chips += chips_earned
	
	var round_success = score >= round_target
	emit_signal("round_completed", round_success, score)
	emit_signal("chips_updated", current_chips)
	
	if round_success:
		start_new_round()

func game_over() -> bool:
	# Game is over if we can't afford to redraw and have no redraws left
	return current_chips < REDRAW_COST and redraws_remaining == 0 