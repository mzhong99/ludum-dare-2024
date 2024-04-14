extends Node
class_name Utility

static func search_children_by_name(node: Node, search_name: String, recursive: bool = false, default_value = null):
	for child in node.get_children():
		if child.name == search_name:
			return child
		elif recursive:
			return search_children_by_name(node, search_name, recursive, default_value)
	return default_value

static func create_timer(caller: Node, wait_time: float = 1.0,
	callback: String = "", one_shot: bool = true, autostart: bool = false) -> Timer:

	var timer: Timer = Timer.new()
	timer.one_shot = one_shot
	timer.autostart = autostart
	if wait_time > 0:
		timer.wait_time = wait_time
	if callback.length() > 0:
		timer.connect("timeout", Callable(caller, callback))
	caller.add_child(timer)
	return timer

static func percent_left(timer: Timer):
	return timer.time_left / timer.wait_time

static func percent_progress(timer: Timer) -> float:
	return (timer.wait_time - timer.time_left) / timer.wait_time

static func permute(arr: Array) -> Array:
	var result = []
	if arr.size() == 0:
		return []
	if arr.size() == 1:
		return [arr]
	if arr.size() == 2:
		return [[arr[0], arr[1]], [arr[1], arr[0]]]

	for i in range(arr.size()):
		var tmp = arr.pop_at(i)
		var subperms = permute(arr)
		result.append_array(subperms)
		arr.insert(i, tmp)
		for j in range(subperms.size()):
			result[result.size() - 1 - j].insert(0, tmp)                
	return result

static func iter_all(iterable, method: String, args = []) -> bool:
	for node in iterable:
		if not node.callv(method, args):
			return false
	return true

static func iter_not_all(iterable, method: String, args = []) -> bool:
	return not iter_all(iterable, method, args)

static func iter_any(iterable, method: String, args = []) -> bool:
	for node in iterable:
		if node.callv(method, args):
			return true
	return false

static func iter_none(iterable, method: String, args = []) -> bool:
	return not iter_any(iterable, method, args)

static func iter_call(iterable, method: String, args = []) -> void:
	for node in iterable:
		node.callv(method, args)

static func subset_match_property(iterable, property: String, matching) -> Array:
	var result = []
	for node in iterable:
		if node.get(property) == matching:
			result.append(node)
	return result

static func find_match_property(iterable, property: String, matching):
	for node in iterable:
		if node.get(property) == matching:
			return node
	return null

static func sinc(x: float, zero_threshold: float = 0.001):
	if abs(x) < zero_threshold:
		var threshold_sinc = sin(zero_threshold) / zero_threshold
		return remap(abs(x), 0, zero_threshold, 1.0, threshold_sinc)
	return sin(x) / x

static func vary(val: float, variance: float = 1.0) -> float:
	return val * pow(variance, randf_range(-1.0, 1.0))

static func random_triangle_point(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))

static func random_point_in_polygon(polygon: PackedVector2Array) -> Vector2:
	var poly_indices = Geometry2D.triangulate_polygon(polygon)
	
	@warning_ignore("integer_division")
	var tri_idx = int((randi() % len(poly_indices)) / 3)
	var A = polygon[poly_indices[(tri_idx * 3) + 0]]
	var B = polygon[poly_indices[(tri_idx * 3) + 1]]
	var C = polygon[poly_indices[(tri_idx * 3) + 2]]
	return random_triangle_point(A, B, C)

static func harmonic_sum(x: int) -> float:
	var sg = sign(x)
	if x < 0: x *= -1
	var sum = 0.0
	for i in range(x):
		sum += 1.0 / float(i + 1.0)
	return sum * sg

static func random_choice(arr: Array):
	if arr.is_empty():
		return null
	return arr[randi() % len(arr)]

static func closest_node2d(source: Node2D, candidates: Array) -> Node2D:
	if candidates.is_empty():
		return null
	
	var best: Node2D = candidates.front()
	for node in candidates:
		var node2d: Node2D = node as Node2D
		var best_dist = best.global_position.distance_to(source.global_position)
		var candidate_dist = node2d.global_position.distance_to(source.global_position)
		if candidate_dist < best_dist:
			best = node2d
	return best

static func area_under_curve(curve: Curve):
	var dx = 1.0 / float(curve.bake_resolution)
	var area = 0.0
	for i in range(curve.bake_resolution):
		var y = curve.interpolate_baked(float(i) / float(curve.bake_resolution))
		area += y * dx
	return area

static func create_rect(width: float, height: float, percent: float = 1.0) -> PackedVector2Array:
	var topleft = Vector2(-width / 2, -height / 2)
	var botleft = Vector2(-width / 2, +height / 2)
	var topright = Vector2((-width / 2) + (width * percent), -height / 2)
	var botright = Vector2((-width / 2) + (width * percent), +height / 2)
	return PackedVector2Array([topleft, topright, botright, botleft])

static func create_offset_rect(width: float, height: float) -> PackedVector2Array:
	var topleft = Vector2(0, -height / 2)
	var botleft = Vector2(0, +height / 2)
	var topright = Vector2(width, -height / 2)
	var botright = Vector2(width, +height / 2)
	return PackedVector2Array([topleft, topright, botright, botleft])

static func longest_matching_prefix(strings: Array[String]) -> String:
	var result: String = ""
	if len(strings) == 0:
		return result

	var haystack: Array[String] = strings.duplicate()
	haystack.sort_custom(func(a, b): return len(a) < len(b))
	var needle = haystack[0]
	for i in range(len(needle)):
		var all_match: bool = true
		for candidate in haystack:
			if candidate[i] != needle[i]:
				all_match = false
		if not all_match:
			break
		result += needle[i]

	return result

static func tile_coord_to_gpos(tilemap_coord: Vector2i, tilemap: TileMap) -> Vector2:
	if tilemap != null:
		return tilemap.to_global(tilemap.map_to_local(tilemap_coord))
	return Vector2.ZERO

static func gpos_to_tile_coord(gpos: Vector2, tilemap: TileMap) -> Vector2i:
	if tilemap != null:
		return tilemap.local_to_map(tilemap.to_local(gpos))
	print("TILE CONVERSION FAILED, RETURN ORIGIN")
	return Vector2i.ZERO

static func find_tilemap_from(node: Node):
	if node == null:
		return null
	if node is TileMap:
		return node

	for child in node.get_children():
		var tilemap = find_tilemap_from(child)
		if tilemap != null:
			return tilemap

	return null
