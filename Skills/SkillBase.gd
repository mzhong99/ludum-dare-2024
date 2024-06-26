extends Node2D
class_name SkillBase

@export var cooldown_sec: float = 0.5
@export var windup_sec: float = 0.1
@export var winddown_sec: float = 0.2
@export var mana_cost: float = 20.0

@export var skill_spawner: PackedScene
@export var is_channel_skill: bool = false

@export var channel_progress = 1.0

@onready var cooldown_timer: Timer = Utility.create_timer(self, cooldown_sec)
@onready var windup_timer: Timer = Utility.create_timer(self, windup_sec, "_on_windup_finished")
@onready var winddown_timer: Timer = Utility.create_timer(self, winddown_sec, "_on_winddown_finished")

var action_press = ""

func _ready():
	pass # Replace with function body.

func _on_windup_finished() -> void:
	var skill = skill_spawner.instantiate()
	var child_owner: Node2D = self

	while is_instance_of(child_owner.get_parent(), Node2D):
		child_owner = child_owner.get_parent()
	child_owner.add_child(skill)
	skill.global_position = self.get_parent().global_position

func is_windup() -> bool:
	return windup_timer.time_left > 0

func is_casting_active() -> bool:
	return windup_timer.time_left > 0 or winddown_timer.time_left > 0

func is_cooling_down() -> bool:
	return cooldown_timer.time_left > 0

func start_cast(action_press: String) -> bool:
	self.action_press = action_press
	if not self.is_cooling_down():
		windup_timer.start()
		cooldown_timer.start()
		return true
	return false

func get_cast_percent() -> float:
	if self.is_windup():
		return Utility.percent_progress(windup_timer)
	if self.is_casting_active():
		return Utility.percent_progress(winddown_timer)
	return 1.0

func _process(_delta: float):
	if not self.is_channel_skill:
		return
	if self.is_windup():
		if Input.is_action_just_released(action_press):
			windup_timer.stop()
			_on_windup_finished()
			print_debug("Channel released")
		else:
			channel_progress = Utility.percent_progress(windup_timer)
