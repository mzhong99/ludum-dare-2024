extends Node2D

@export var villager_scene: PackedScene = preload("res://Entity/EnemyVillager.tscn")
var time_elapsed = 0
var souls_gathered = 0
var enemies_spawned_count = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update health and mana bars
	$HUD/ManaBar.value = $Player.mana_current
	$HUD/HealthBar.value = $Player.health_current
	
	# if player is dead, do stuff:
	if $Player.is_dead:
		$HUD/Restart.visible = true

func _on_enemy_villager_spawn_timer_timeout():
	# instantiate mob
	var enemy_villager = villager_scene.instantiate()
	var mob_spawn_location = $Arena/MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#mob_spawn_location.position = Vector2(10,10)
	enemy_villager.position = mob_spawn_location.position
	
	add_child(enemy_villager)
	
	# update number of enemies spawned counter
	enemies_spawned_count += 1
	$HUD/EnemiesSpawnedLbl.text = str("Enemies Spawned: ", enemies_spawned_count) 
	
	# restart timer
	$EnemyVillagerSpawnTimer.start()


func _on_time_elapsed_timeout():
	# increase time elapsed
	time_elapsed += 1
	
	# redraw time elapsed text on the screen
	$HUD/ElapsedTimeLbl.text = str("Time Elspased: ", time_elapsed)
	
	# restart timer
	$TimeElapsed.start()


func _update_souls_gathered():
	$HUD/SoulsGatheredLbl.text = str("Souls Gathered: ", souls_gathered)


func _on_player_on_death():
	print("on_player_on_death")
	$HUD/Restart.visible = true
