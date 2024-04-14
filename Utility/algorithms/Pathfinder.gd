extends Node
class_name Pathfinder

static func generate_coord_path(
	coord_start: Vector2i, coord_goal: Vector2i, tilemap: TileMap, layer: int = 0, cutoff_nodes: int = 256) -> Array[Vector2i]:
	
	if tilemap.get_cell_tile_data(layer, coord_goal) != null:
		return []
	
	var frontier: Array[Vector2i] = [coord_start]
	var seen: Dictionary = {}
	while not frontier.is_empty():
		cutoff_nodes -= 1
		if cutoff_nodes <= 0:
			return []
		var coord: Vector2i = frontier.pop_front()
		if coord == coord_goal:
			break

		var neighbors: Array[Vector2i] = [
			coord + Vector2i.RIGHT,
			coord + Vector2i.LEFT,
			coord + Vector2i.UP,
			coord + Vector2i.DOWN]
		neighbors.shuffle()
		
		for neighbor in neighbors:
			if not seen.has(neighbor) and tilemap.get_cell_tile_data(layer, neighbor) == null:
				seen[neighbor] = coord
				frontier.push_back(neighbor)

	if seen.get(coord_goal) == null:
		return []

	var readback_chain: Array[Vector2i] = []
	var readback_coord: Vector2i = coord_goal
	while readback_coord != coord_start:
		readback_chain.push_front(readback_coord)
		readback_coord = seen.get(readback_coord)

	return readback_chain
