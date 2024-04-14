extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("PLAYER")

@export var player_follow_distance_far = 250
@export var player_follow_distance_close = 150
@export var speed = 40
@export var running_multiplier = 2.0
@export var wander_radius = 40

enum GOALS {enemy, player, wander, none}
var goal = GOALS.none
var wander_target: Vector2

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	pass
	
	
# General plan for movement:
# Rat will randomly wander but stay near player. If an enemy comes close, rat will charge the enemy.
func process_movement(delta):
	# If engaged with an enemy, keep doing that
	if (goal == GOALS.enemy):
		return

	# Determine if should run to the player now
	var vec_to_player = player.global_position - self.global_position
	var distance_to_player = vec_to_player.length()
	if (distance_to_player >= player_follow_distance_far):
		goal = GOALS.player
	if (goal != GOALS.wander and distance_to_player < player_follow_distance_close):
		goal = GOALS.none
	if (goal == GOALS.player):
		var amount = delta * speed * running_multiplier
		self.global_position = self.global_position.move_toward(player.global_position, amount)
		return
	
	# Wander if nothing else happened
	print(goal)
	if (goal == GOALS.wander):
		var amount = delta * speed
		self.global_position = self.global_position.move_toward(wander_target, amount)
		if (self.global_position.is_equal_approx(wander_target)):
			goal = GOALS.none
	elif (goal == GOALS.none):
		goal = GOALS.wander
		var x = rng.randf_range(-wander_radius, wander_radius)
		var y = rng.randf_range(-wander_radius, wander_radius)
		wander_target = self.global_position + Vector2(x,y)
		
	
	
