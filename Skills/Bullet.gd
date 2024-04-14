extends Node2D

@export var speed_pps: float = 1000
@export var despawn_sec: float = 1.0

@export var despawn_timer: Timer = Utility.create_timer(self, despawn_sec, "_on_despawn_timer_expired", true, true)

var velocity_unit: Vector2 = Vector2.RIGHT

func _on_despawn_timer_expired() -> void:
	print_debug("despawned")
	self.queue_free()

func _ready():
	var player: Node2D = get_tree().get_first_node_in_group("PLAYER")
	if player != null:
		velocity_unit = player.global_position.direction_to(get_global_mouse_position())
		print_debug("spawned")

func _process(delta: float):
	self.global_position += delta * velocity_unit * speed_pps
