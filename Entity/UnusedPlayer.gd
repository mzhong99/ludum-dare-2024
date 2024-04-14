extends Node2D

@onready var skill_table = {
	"skill_q": $BulletSkill,
	"skill_w": $FireballSkill
}

@onready var skill_active: SkillBase = skill_table[skill_table.keys().front()]

# ---Movement variables---
var is_moving = false
var location_to_move_to = Vector2.ZERO
@export var MOVEMENT_SPEED = 100
# ---End Movement variables---

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process_spellcast_inputs():
	if skill_active.is_casting_active():
		return

	for skill_input in skill_table.keys():
		var skill_base: SkillBase = skill_table[skill_input] as SkillBase
		if Input.is_action_just_released(skill_input):
			if skill_base.start_cast():
				print_debug("skill cast started:", skill_input)
				skill_active = skill_base
				return

func _draw_spellcast_cooldown_view():
	var filled_rect = Utility.create_rect(128, 16, skill_active.get_cast_percent())
	var backing_rect = Utility.create_rect(128, 16, 1.0)
	draw_colored_polygon(backing_rect, Color.BLACK)
	draw_colored_polygon(filled_rect, Color.WHITE)

func _process(delta):
	_process_spellcast_inputs()
	process_movement(delta)
	queue_redraw()

func process_movement(delta):
	if (Input.is_action_just_pressed("gameplay_move_player")):
		is_moving = true
		location_to_move_to = get_global_mouse_position()
	if (is_moving):
		var amount_to_move = delta * MOVEMENT_SPEED
		self.global_position = self.global_position.move_toward(location_to_move_to, amount_to_move)
		if (self.global_position == location_to_move_to):
			is_moving = false

func _draw():
	_draw_spellcast_cooldown_view()
