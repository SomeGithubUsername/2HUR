extends "res://scripts/Enemy.gd"

var _life_bars = []
# Las diferentes barras de vida del jefe 


func damage(damage_points):
	print("Boss hitted")
	_life_bars[0] -= damage_points
	if _life_bars[0] <= 0:
	# Si la barra de vida esta vocia
		_life_bars.pop_front()
		if _life_bars.empty():
		# Si todas las barras de vida han sido vaciadas
			_boss_killed()
		else:
			_load_next_spell()

func _load_next_spell():
	pass

func _boss_killed():
	# Hacer la animacion de derrota y soltar objetos
	emit_signal("enemie_deleted")
	self.queue_free()
