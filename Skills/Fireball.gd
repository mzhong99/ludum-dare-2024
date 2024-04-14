extends Node2D

@export var speed_pps: float = 400
@export var despawn_sec: float = 2.0
@export var explode_sec: float = 0.5
@export var explode_radius: float = 32.0

@export var despawn_timer: Timer = Utility.create_timer(self, despawn_sec, "_on_explode", true, true)
@export var explode_timer: Timer = Utility.create_timer(self, explode_sec, "_despawn")
@onready var animated_sprite: AnimatedSprite2D = $BaseAnimatedSprite2D
@onready var explode_sprites: Array = [
	$Explosions/ExplodeAnimatedSprite2D1,
	$Explosions/ExplodeAnimatedSprite2D2,
	$Explosions/ExplodeAnimatedSprite2D3,
	$Explosions/ExplodeAnimatedSprite2D4
]

var exploding: bool = false
var velocity_unit: Vector2 = Vector2.ZERO

func _despawn() -> void:
	queue_free()

func _on_explode() -> void:
	if exploding:
		return

	explode_timer.start()
	exploding = true
	animated_sprite.hide()
	for i in range(len(explode_sprites)):
		var sprite: AnimatedSprite2D = explode_sprites[i] as AnimatedSprite2D
		sprite.play()
		sprite.show()
		var sprite_offset = velocity_unit.angle() + lerpf(0, 2 * PI, float(i) / len(explode_sprites))
		sprite.position = Vector2.RIGHT.rotated(sprite_offset) * explode_radius
	speed_pps = 0

func _ready():
	var player: Node2D = get_tree().get_first_node_in_group("PLAYER")
	if player != null:
		velocity_unit = player.global_position.direction_to(get_global_mouse_position())
		animated_sprite.global_rotation = velocity_unit.angle() + (PI * 0.5)
		print(animated_sprite.global_rotation)
	animated_sprite.play()
	despawn_timer.start()

func _process(delta: float):
	self.global_position += delta * velocity_unit * speed_pps
