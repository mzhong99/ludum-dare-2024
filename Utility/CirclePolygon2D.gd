@tool
extends Polygon2D
class_name CirclePolygon2D

@export var override_parent_radius: bool = true
@export var radius: float = 100.0: set = set_radius
@export var num_points: int = 32

func repopulate_polygon() -> void:
	var points = []
	for i in range(num_points):
		var angle = remap(i, 0, num_points, 0, 2 * PI)
		points.append(Vector2.RIGHT.rotated(angle) * radius)
	polygon = PackedVector2Array(points)

func set_radius(new_radius: float) -> void:
	radius = new_radius
	repopulate_polygon()

func _ready():
	if not override_parent_radius:
		var iter = get_parent() as Node
		while iter != null:
			var iter_radius = iter.get("radius")
			if iter_radius != null:
				radius = iter_radius
				break
			iter = iter.get_parent() as Node
	repopulate_polygon()

func _process(_delta):
	if not override_parent_radius:
		var iter = get_parent() as Node
		while iter != null:
			var iter_radius = iter.get("radius")
			if iter_radius != null:
				radius = iter_radius
				break
			iter = iter.get_parent() as Node
