@tool
extends CollisionPolygon2D
class_name CircleCollisionPolygon2D

@export var radius: float = 100.0
@export var num_points: int = 32

func repopulate_polygon() -> void:
	var points = []
	for i in range(num_points):
		var angle = remap(i, 0, num_points, 0, 2 * PI)
		points.append(Vector2.RIGHT.rotated(angle) * radius)
	polygon = PackedVector2Array(points)

func _ready():
	repopulate_polygon()

func _process(_delta):
	repopulate_polygon()
