extends Control

@export var preload_world: PackedScene = preload("res://World/world.tscn")
var world = null

# Called when the node enters the scene tree for the first time.
func _ready():
	world = preload_world.instantiate()
	add_child(world)
	world.connect("world_done", _world_completed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _world_completed():
	print("DEATH DEATH DEATH DEATH DEATH")
	$CanvasLayer/BoxContainer/Restart.visible = true
	
		#world.queue_free()

func _on_restart_pressed():
	if world != null: 
		world.queue_free()
	world = preload_world.instantiate()
	
	add_child(world)
	$CanvasLayer/BoxContainer/Restart.visible = false
	
	world.connect("world_done", _world_completed)

