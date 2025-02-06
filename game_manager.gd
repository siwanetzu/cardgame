extends Node

signal chips_updated(new_amount: int)
signal round_updated(round_num: int, target: int)
signal redraws_updated(remaining: int)
signal hands_updated(remaining: int)
signal round_completed(success: bool, score: int)
signal game_over(total_score: int, round_reached: int)

var total_score: int = 0
var current_round: int = 1
var redraws_remaining: int = 4  # Start with 4 redraws per round
var hands_remaining: int = 4    # Start with 4 hands per round
var round_target: int = 500    # Initial target score

# Round target increases with each round
const TARGET_INCREASE_FACTOR = 1.5
const STARTING_HANDS = 4
const STARTING_REDRAWS = 4

func _ready():
	reset_game()

func reset_game():
	total_score = 0
	current_round = 1
	round_target = 500
	reset_round_resources()
	
	emit_signal("chips_updated", total_score)
	emit_signal("round_updated", current_round, round_target)
	emit_signal("redraws_updated", redraws_remaining)
	emit_signal("hands_updated", hands_remaining)

func reset_round_resources():
	redraws_remaining = STARTING_REDRAWS
	hands_remaining = STARTING_HANDS

func start_new_round():
	current_round += 1
	round_target = int(round_target * TARGET_INCREASE_FACTOR)
	reset_round_resources()
	
	emit_signal("round_updated", current_round, round_target)
	emit_signal("redraws_updated", redraws_remaining)
	emit_signal("hands_updated", hands_remaining)

func can_redraw() -> bool:
	return redraws_remaining > 0 and hands_remaining > 0

func redraw_hand() -> bool:
	if can_redraw():
		redraws_remaining -= 1
		emit_signal("redraws_updated", redraws_remaining)
		return true
	return false

func submit_hand(score: int):
	hands_remaining -= 1
	total_score += score
	
	var round_success = score >= round_target
	emit_signal("round_completed", round_success, score)
	emit_signal("chips_updated", total_score)
	emit_signal("hands_updated", hands_remaining)
	
	if round_success:
		start_new_round()
	elif hands_remaining <= 0:
		# Game over if no hands left and target not reached
		emit_signal("game_over", total_score, current_round)

func is_game_over() -> bool:
	# Game is over if we're out of hands and haven't reached the target
	return hands_remaining <= 0 
