extends Control  # Ensure this is a UI node

var _rank: String = "A"
var _suit: String = "♠"
var is_selected: bool = false
var original_position: Vector2
var HOVER_TINT = Color(0.85, 0.85, 0.85, 1.0)  # Dark grey tint
var SELECTION_TINT = Color(0.8, 0.9, 1.0, 1.0)  # Subtle blue tint
var SELECTION_RAISE = -20  # Pixels to raise the card when selected
var HOVER_RAISE = -10  # Pixels to raise when hovering

@export var rank: String:
	get:
		return _rank
	set(value):
		_rank = value
		print("Setting rank to: ", value)
		update_display()
		
@export var suit: String:
	get:
		return _suit
	set(value):
		_suit = value
		print("Setting suit to: ", value)
		update_display()

func _ready():
	print("Card ready with rank:", _rank, " suit:", _suit)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	original_position = position
	update_display()

func _on_mouse_entered():
	if not is_selected:
		modulate = HOVER_TINT
		# Create a smooth animation for raising the card
		var tween = create_tween()
		tween.tween_property(self, "position:y", original_position.y + HOVER_RAISE, 0.1).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited():
	if not is_selected:
		modulate = Color(1, 1, 1, 1.0)
		# Smoothly return to original position
		var tween = create_tween()
		tween.tween_property(self, "position:y", original_position.y, 0.1).set_trans(Tween.TRANS_SINE)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			toggle_selection()

func toggle_selection():
	is_selected = !is_selected
	var tween = create_tween()
	
	if is_selected:
		modulate = SELECTION_TINT
		# Raise the card higher than hover and add blue tint
		tween.tween_property(self, "position:y", original_position.y + SELECTION_RAISE, 0.15).set_trans(Tween.TRANS_SINE)
		# Add glow effect
		$CardSprite.material = load("res://glow_material.tres") if ResourceLoader.exists("res://glow_material.tres") else null
	else:
		modulate = Color(1, 1, 1, 1.0)
		# Return to original position
		tween.tween_property(self, "position:y", original_position.y, 0.15).set_trans(Tween.TRANS_SINE)
		$CardSprite.material = null
	
	# Emit signal for card manager to handle game logic
	selection_changed.emit(self, is_selected)

# Signal to notify when card selection changes
signal selection_changed(card, is_selected)

func update_display():
	if not is_node_ready():
		await ready
		
	if has_node("RankLabel") and has_node("SuitLabel"):
		print("Updating display for card - Rank:", _rank, " Suit:", _suit)
		$RankLabel.text = _rank
		$SuitLabel.text = _suit
		
		# Update color based on suit
		var color = Color(0, 0, 0, 1)  # Default to black
		if _suit in ["♥", "♦"]:
			color = Color(1, 0, 0, 1)  # Red for hearts and diamonds
		elif _suit in ["♠", "♣"]:
			color = Color(0, 0, 0, 1)  # Black for spades and clubs
			
		# Make sure the labels are visible by setting a white background or outline
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 1, 1, 0.9)  # White background with slight transparency
		style.corner_radius_top_left = 5
		style.corner_radius_top_right = 5
		style.corner_radius_bottom_left = 5
		style.corner_radius_bottom_right = 5
		style.expand_margin_left = 5
		style.expand_margin_right = 5
		
		$RankLabel.add_theme_stylebox_override("normal", style)
		$SuitLabel.add_theme_stylebox_override("normal", style.duplicate())
		
		$RankLabel.add_theme_color_override("font_color", color)
		$SuitLabel.add_theme_color_override("font_color", color)
	else:
		print("Warning: Labels not found for card with rank:", _rank, " suit:", _suit)
