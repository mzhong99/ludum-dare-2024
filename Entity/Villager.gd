extends Node2D

@export var chase_speed: float = 100
@export var is_enemy: bool = true

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play()
	pass

func _process(delta):
	var target_node2d: Node2D = get_tree().get_first_node_in_group("PLAYER")
	var distance_max: float = INF
	if not is_enemy:
		var candidates = get_tree().get_nodes_in_group("ENEMIES")
		for candidate in candidates:
			if candidate == self:
				continue
			var candidate_distance = self.global_position.distance_to(candidate.global_position)
			if distance_max > candidate_distance:
				distance_max = candidate_distance
				target_node2d = candidate
	if target_node2d != null:
		self.global_position += self.global_position.direction_to(target_node2d.global_position) * chase_speed * delta
