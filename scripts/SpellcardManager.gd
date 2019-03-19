extends Node
signal spellcard_ended

onready var DeffaultShootsScript = preload("res://scripts/DefaultShoots.gd")
var _frame_counter = 0
var _spell = null
var _DeffShoots = null
var _affected_group = null
var _character = null
var _CoolDownTimer = null
var _ShootContainer = null
var _max_fames = 0
var _cooldown = false
var _in_cooldown = false
var _cooldown_time = 0.0

var _in_spell = false
var enable_spell_use = true setget set_spell_use, get_spell_use 
# Habilita o desabilita el uso de spells, deshabilitar su uso en medio de un spell no lo detendra

func set_spell_use(use):
	enable_spell_use = use

func get_spell_use():
	return enable_spell_use

func is_in_cooldown() -> bool:
	var tl = _CoolDownTimer.time_left
	return tl > 0

func is_in_spell():
	""" Verifica si el spell esta actibo"""
	return _in_spell

func set_cooldown(seconds):
	""" Fija el tiempo de espera antes de usar el siguente spell"""
	_cooldown_time = seconds
	_cooldown = (seconds >= 0)
	if _cooldown:
		_CoolDownTimer.wait_time = seconds
	else:
		_CoolDownTimer.stop()


func start_spell(spell_name):
	""" Inicia un spell"""
	if spell_name == "patchoulol_flare":
		_spell = funcref(self, "_patchoulol_flare")
	elif spell_name == "radiotherapy":
		_spell = funcref(self, "_radiotherapy")
	set_process(enable_spell_use and not (_in_spell or _in_cooldown))
	# Si puede usar spells, no esta en un spell y el tiempo de enfriamiento se ha agotado

func set_frame_limit(frames):
	self._max_fames = frames

func _init(affected_group, shoot_container):
	self._affected_group = affected_group
	self._ShootContainer = shoot_container

func _ready():
	_character = get_node("../")
	_DeffShoots = DeffaultShootsScript.new()
	self._CoolDownTimer = Timer.new()
	self.add_child(_CoolDownTimer)
	_CoolDownTimer.connect("timeout", self, "_on_cooldown_timeout")
	_CoolDownTimer.autostart = false
	_DeffShoots = DeffaultShootsScript.new()
	self.set_process(false)

func _on_cooldown_timeout():
	_in_cooldown = false

func _process(delta):
	_frame_counter += 1
	_in_spell = true
	if _max_fames > 0 and _frame_counter == _max_fames:
		set_process(false)
		_in_spell = false
		emit_signal("spellcard_ended")
		_frame_counter = 0
		if _cooldown:
			_CoolDownTimer.start()
			_in_cooldown = true
		else:
			_in_cooldown = false
		return
	_spell.call_func()

# ------------------------------------------------------------ SPELLS
func _patchoulol_flare():
	var pos = _character.global_position
	var bullet = null
	bullet = _DeffShoots.bullet_a(pos, _affected_group, -GlobalScript.HALF_PI + 0.2*(1 - 2*(_frame_counter & 1))*_frame_counter, 300)
	_ShootContainer.add_child(bullet)

func _radiotherapy():
	if _frame_counter & 7 != 0:
		return
	var pos = _character.global_position
	var laser = null
	laser = _DeffShoots.laser_a(pos, _affected_group, 0.3 * (1 - 2*(_frame_counter & 1)), 800, 2.1)
	laser.angular_velocity = 0.05
	_ShootContainer.add_child(laser)