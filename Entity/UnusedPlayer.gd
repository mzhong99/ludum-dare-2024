extends Node2D

@onready var skill_table = {
	"skill_q": $BulletSkill
}

@onready var skill_active: SkillBase = skill_table[skill_table.keys().front()]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process_spellcast_inputs():
	if skill_active.is_casting_active():
		return

	for skill_input in skill_table.keys():
		var skill_base: SkillBase = skill_table[skill_input] as SkillBase
		if Input.is_action_just_released(skill_input):
			if skill_active.start_cast():
				print_debug("skill cast started:", skill_input)
				skill_active = skill_base
				return

func _process(delta):
	_process_spellcast_inputs()

