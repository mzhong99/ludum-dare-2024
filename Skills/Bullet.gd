extends Node2D

@export var speed_pps: float = 400
@export var despawn_sec: float = 2.0
@export var damage: float = 10.0

@export var despawn_timer: Timer = Utility.create_timer(self, despawn_sec, "_on_despawn_timer_expired", true, true)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

var velocity_unit: Vector2 = Vector2.ZERO

func _on_despawn_timer_expired() -> void:
	self.queue_free()

func _ready():
	var player: Node2D = get_tree().get_first_node_in_group("PLAYER")
	if player != null:
		velocity_unit = player.global_position.direction_to(get_global_mouse_position())
		animated_sprite.global_rotation = velocity_unit.angle() + (PI * 0.5)
		hitbox.global_rotation = velocity_unit.angle() + (PI * 0.5)
	animated_sprite.play()

func _process(delta: float):
	self.global_position += delta * velocity_unit * speed_pps

func _on_area_2d_area_entered(area):
	var parent: Node2D = area.get_parent() as Node2D
	if parent.has_method("receive_damage"):
		parent.receive_damage(damage)
	self.queue_free()
