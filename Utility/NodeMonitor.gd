extends Label
class_name NodeMonitor
@export var watchlist: Array[String] = []

@onready var _global_position_offset = self.global_position 

func _create_property_line(property_name: String):
	var value = str(self.get_parent().get(property_name))
	return "%s: %s\n" % [property_name, value]

func find_parent_node2d():
	var node = get_parent()
	while not (node is Node2D) and node != null:
		node = node.get_parent()
	return null

func _process(_delta):
	self.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	
	self.text = "%s\n" % [self.get_parent().name]
	for property_name in self.watchlist:
		self.text += _create_property_line(property_name)

	var node2d = find_parent_node2d()
	if node2d != null:
		self.global_position = node2d.global_position + self._global_position_offset + (0.5 * self.size)
