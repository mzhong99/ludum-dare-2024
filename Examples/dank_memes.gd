extends Node2D

@export var MOVEMENT_VELOCITY = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_unit = Input.get_vector("gameplay_move_left", "gameplay_move_right", "gameplay_move_up", "gameplay_move_down")
	self.global_position += movement_unit * MOVEMENT_VELOCITY * delta
