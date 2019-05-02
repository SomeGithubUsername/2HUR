extends Node
signal spellcard_ended

var _frame_counter = 0
var _DeffShoots = null
var _affected_group = null
var _character = null
var _CoolDownTimer = null
var _ShootContainer = null
var _max_fames = 0
var _in_cooldown = false
var _cooldown_time = 0.0

var _spell = null
# Guarda una referencia a la funcion que se llamara mientras se realiza el spell

var _in_spell = false
var enable_spell_use = true setget set_spell_use, get_spell_use 
# Habilita o desabilita el uso de spells, deshabilitar su uso en medio de un spell no lo detendra

func set_spell_use(use):
	if not use and self._in_spell:
		# Evita que se desabilite el uso de spells en medio de un spell
		return 
	enable_spell_use = use

func get_spell_use() -> bool:
	return enable_spell_use

func is_in_cooldown() -> bool:
	""" Verifica si el tiempo de enfriamiento aun no esta agotado"""
	return _cooldown_time > 0 and _CoolDownTimer.time_left > 0

func is_in_spell() -> bool:
	""" Verifica si el spell esta activo"""
	return _in_spell

func set_cooldown(seconds):
	""" Fija el tiempo de espera antes de usar el siguente spell"""
	_cooldown_time = seconds
	if _cooldown_time > 0:
		_CoolDownTimer.wait_time = seconds
	else:
		_CoolDownTimer.stop()

func start_spell(spell_name):
	""" Inicia un spell"""
	if self._in_spell:
		# Evita que se inicie un spell en medio de otro spell
		return
	_spell = funcref(self, "_" + spell_name)
	assert(_spell != null)
	set_process(enable_spell_use and not (_in_spell or _in_cooldown))
	# Si puede usar spells, no esta en un spell y el tiempo de enfriamiento se ha agotado

func set_frame_limit(frames):
	""" Fija el numero de cuadros que durara el spell, si < 0, se repetira indefinidamente """
	self._max_fames = frames

func _init(user, affected_group, shoot_container):
	self._character = user
	self._affected_group = affected_group
	self._ShootContainer = shoot_container
	self._CoolDownTimer = Timer.new()
	var DeffShootsScript = load("res://scripts/shots/DefaultShoots.gd")
	_CoolDownTimer.autostart = false
	_DeffShoots = DeffShootsScript.new()

func _ready():
	self.add_child(_CoolDownTimer)
	_CoolDownTimer.connect("timeout", self, "_on_cooldown_timeout")
	self.set_process(false)

func _on_cooldown_timeout():
	""" Se llama cuando el tiempo de enfriamiento ha sido agotado"""
	_in_cooldown = false

func _process(delta):
	_frame_counter += 1
	_in_spell = true
	if _max_fames > 0 and _frame_counter == _max_fames:
		# Si existe un limite de cuadros y se ha agotado el limite
		set_process(false)
		_in_spell = false
		_frame_counter = 0
		_in_cooldown = _cooldown_time > 0
		if _in_cooldown:
			# Si hay tiempo de enfriamiento
			_CoolDownTimer.start()
		emit_signal("spellcard_ended")
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
	laser.angular_velocity = 0.051
	_ShootContainer.add_child(laser)