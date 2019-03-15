extends Node
signal spellcard_ended

onready var DeffaultShootsScript = preload("res://scripts/DefaultShoots.gd")
onready var ScheduleScript = preload("res://scripts/Schedule.gd")
var _frame_counter = 0
var _spells = []
var _DeffShoots = null
var _affected_group = null
var _character = null

var _in_spell
var enable_spell_use = false
# Habilita o desabilita el uso de spells, deshabilitar su uso en medio de un spell no lo detendra

func is_in_spell():
	""" Verifica si el spell esta actibo"""
	return _in_spell

func load_spellcard(func_name, object):
	pass

func set_cooldown(seconds):
	""" Fija el tiempo de espera antes de usar el siguente spell"""
	pass

func start_spell(index=0):
	""" Inicia un spell, si esta fuera de rago causa un error"""
	pass

func _ready():
	_character = get_node("../")
	_DeffShoots = DeffaultShootsScript.new()
	self.set_process(false)

func _process(delta):
	_frame_counter += 1
