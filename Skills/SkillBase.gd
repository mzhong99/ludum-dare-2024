extends Node2D
class_name SkillBase

@export var cooldown_sec: float = 0.5
@export var windup_sec: float = 0.1
@export var winddown_sec: float = 0.2

@export var skill_spawner: PackedScene

@onready var cooldown_timer: Timer = Utility.create_timer(self, cooldown_sec)
@onready var windup_timer: Timer = Utility.create_timer(self, windup_sec, "_on_windup_finished")
@onready var winddown_timer: Timer = Utility.create_timer(self, windup_sec, "_on_winddown_finished")

func _ready():
	pass # Replace with function body.

func _on_windup_finished() -> void:
	var skill = skill_spawner.instantiate()
	var child_owner: Node2D = self

	while is_instance_of(child_owner.get_parent(), Node2D):
		child_owner = child_owner.get_parent()
	child_owner.add_child(skill)
	skill.global_position = self.get_parent().global_position

func is_casting_active() -> bool:
	return windup_timer.time_left > 0 or winddown_timer.time_left > 0

func is_cooling_down() -> bool:
	return cooldown_timer.time_left > 0

func start_cast() -> bool:
	if not self.is_cooling_down():
		windup_timer.start()
		cooldown_timer.start()
		return true
	return false

func _process(_delta: float):
	pass
