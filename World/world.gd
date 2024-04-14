extends Node2D

@export var villager_scene: PackedScene = preload("res://Entity/EnemyVillager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_villager_spawn_timer_timeout():
	# instantiate mob
	var enemy_villager = villager_scene.instantiate()
	var mob_spawn_location = $Arena/MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#mob_spawn_location.position = Vector2(10,10)
	enemy_villager.position = mob_spawn_location.position
	
	print_debug("mob_spawn_location: ", mob_spawn_location.position)
	add_child(enemy_villager)

	# restart timer
	$EnemyVillagerSpawnTimer.start()
