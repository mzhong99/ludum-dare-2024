extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("PLAYER")

@export var player_follow_distance_far = 250
@export var player_follow_distance_close = 150
@export var speed = 40
@export var running_multiplier = 3
@export var wander_radius = 40
@export var attack_radius = 400

enum GOALS {enemy, player, wander, none}
var goal = GOALS.none
var wander_target: Vector2
var enemy_target: Node2D

var rng = RandomNumberGenerator.new()

var rat_size = 32.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	set_rat_size(rat_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	pass
	
	
func set_rat_size(size):
	rat_size = size
	if (rat_size < 16.0):
		# the rat fucking dies
		queue_free()
	var scale = rat_size / 32.0
	sprite.scale = Vector2(scale, scale)
	
func closeness_needed_to_enemy(enemy):
	return 16.0 + rat_size/2.0
	
# General plan for movement:
# Rat will randomly wander but stay near player. If an enemy comes close, rat will charge the enemy.
func process_movement(delta):
	# If engaged with an enemy, keep doing that

	var enemies = get_tree().get_nodes_in_group("ENEMY")
	for enemy in enemies:
		var dist_to_enemy = (enemy.global_position - self.global_position).length()
		if (dist_to_enemy < attack_radius):
			goal = GOALS.enemy
			enemy_target = enemy
			break
			
	if (goal == GOALS.enemy):
		var amount = delta * speed * running_multiplier
		if (!is_instance_valid(enemy_target)):
			goal = GOALS.none
			return
		self.global_position = self.global_position.move_toward(enemy_target.global_position, amount)
		var needed_dist = closeness_needed_to_enemy(enemy_target)
		if (self.global_position.distance_to(enemy_target.global_position) <= needed_dist):
			print(enemy_target)
			enemy_target.receive_damage(1)
			set_rat_size(rat_size - 4)
			goal = GOALS.none
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
		
	
	
