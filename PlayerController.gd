extends Node2D

@export var MOVEMENT_VELOCITY = 1000
var location_to_move_to: Vector2
var direction_unit: Vector2 = Vector2.ZERO
var is_moving = false

# Move vector v towards dest by amount. Do not overshoot
func move_toward_but_it_works(v: Vector2, dest: Vector2, amount: float):
	var diff = dest - v
	var move = diff.normalized() * amount
	
	var diff_norm = diff.x * diff.x + diff.y * diff.y
	var move_norm = move.x * move.x + move.y * move.y
	
	# If overshoot the move, return the destination
	if (move_norm >= diff_norm):
		return dest
		
	return v + move
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("gameplay_move_player")):
		is_moving = true
		location_to_move_to = get_global_mouse_position()
	if (is_moving):
		var amount_to_move = delta * MOVEMENT_VELOCITY
		self.global_position = move_toward_but_it_works(self.global_position, location_to_move_to, amount_to_move)
		if (self.global_position == location_to_move_to):
			is_moving = false
	pass
