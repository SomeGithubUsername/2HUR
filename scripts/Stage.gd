extends Node

signal stage_ended
var _stage_name = "Test Stage"
var _waves = []
var _current_wave = null

func _ready():
	_waves = $Waves.get_children()
	assert(not _waves.empty())
	load_waves()
	_current_wave = _waves.pop_front()
	# Guarda la primera oleada y la elimina de _waves
	#for w in _waves:
	#	# Quita las oleadas restantes del arbol para que no sean procesadas
	#	$Waves.remove_child(w)
	_current_wave.start()

func set_current_wave(wave_index):
	pass

func load_waves():
	"""Carga que enemigos apareceran en cada oleada"""
	var i = 1
	for w in _waves:
		w.add_to_enemy_schedule(3, 0, 10, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		i += 1

func current_wave_ended():
	if _waves.empty():
	# Si todas las oleadas han sido procesadas
		self.emit_signal("stage_ended")
		self.queue_free()
		return
	var prev_wave = _current_wave
	_current_wave = _waves.pop_front()
	# Obtiene la siguiente oleada y la elimina de _waves
	$Waves.remove_child(prev_wave)
	prev_wave.queue_free()
	_current_wave.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
