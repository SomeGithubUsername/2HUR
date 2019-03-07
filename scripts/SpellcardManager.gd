extends Node
signal spellcard_ended

onready var DeffaultShootsScript = preload("res://scripts/DefaultShoots.gd")
onready var ScheduleScript = preload("res://scripts/Schedule.gd")
var _frame_counter = 0
var _spells = []
var _DeffShoots = null
var _affected_group = null
var _character = null

func load_spellcard_data():
	var spell = ScheduleScript.Schedule.new()
	var pos = _character.global_position
	spell.add_stop(2, _DeffShoots, "bullet_a", [pos, _affected_group, GlobalScript.HALF_PI, 400])
	# Generar Bala tipo A a los 2 segundos
	spell.add_stop(2, _DeffShoots, "bullet_a", [pos, _affected_group, -GlobalScript.HALF_PI, 400])
	spell.add_stop(2, _DeffShoots, "bullet_a", [pos, _affected_group, GlobalScript.QUARTER_PI, 400])
	spell.add_stop(2, _DeffShoots, "bullet_a", [pos, _affected_group, -GlobalScript.QUARTER_PI, 400])
	_spells.append(spell)

func _ready():
	_character = get_node("../")
	_DeffShoots = DeffaultShootsScript.new()
	self.set_process(false)

func _process(delta):
	_frame_counter += 1

func start():
	self.set_process(true)