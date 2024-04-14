extends Node2D

@onready var skill_table = {
	"skill_q": $BulletSkill
}

@onready var skill_active: SkillBase = skill_table[skill_table.keys().front()]

# ---Movement variables---
var is_moving = false
var location_to_move_to = Vector2.ZERO
@export var MOVEMENT_SPEED = 100
# ---End Movement variables---

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process_spellcast_inputs():
	if skill_active.is_casting_active():
		return

	for skill_input in skill_table.keys():
		var skill_base: SkillBase = skill_table[skill_input] as SkillBase
		if Input.is_action_just_pressed(skill_input):
			if skill_active.start_cast():
				print_debug("skill cast started:", skill_input)
				skill_active = skill_base
				return

func process_movement(delta):
	if (Input.is_action_just_pressed("gameplay_move_player")):
		is_moving = true
		location_to_move_to = get_global_mouse_position()
	if (is_moving):
		var amount_to_move = delta * MOVEMENT_SPEED
		self.global_position = self.global_position.move_toward(location_to_move_to, amount_to_move)
		if (self.global_position == location_to_move_to):
			is_moving = false
	

func _process(delta):
	_process_spellcast_inputs()
	process_movement(delta)

