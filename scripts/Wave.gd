extends Node

onready var Dummy = preload("res://scenes/Dummy.tscn")
onready var Rail = preload("res://scenes/Rail.tscn")
var paths = []
#Almacena una referencia a los caminios de una oleada
var _enemy_spawn_schedule = {}
#Almacena inforamcion sobre que tipo de enemigo generar a que tiempo relativo al inicio de la oleada
#time : 0->t, args : [[a1, b1, c1], [a2, b2, c2], ...]
var _enemie_counter = 0

signal wave_ended

func _ready():
	print("Wave @", self.get_instance_id(), " ready")
	$Timer.autostart = false
	$Timer.stop()
	var stage = self.get_node("../../")
	assert(stage.name == "Stage")
	paths = $Paths.get_children()
	assert(paths.size() > 0)
	#un array con todos los caminos
	connect("wave_ended", stage, "current_wave_ended")
	$Timer.wait_time = 1
	#se utiliza para manejar el tiempo en el cual crear enemigos

func start():
	"""Comienza a spawnear enemigos, 
	los enemigos agregados a la lista de spawn despues de llamar a esta funcion no se agregaran"""
	var schedule = []
	var keys = _enemy_spawn_schedule.keys()
	keys.sort()
	#Ordenar las claves de menor a mayor
	var prev_key = keys[0]
	# Convierte el dicionario a una lista de diccionarios ordenados por orden de aparicion que almacenan 
	# el tiempo de retraso antes de generar los enemigos y los argumentos para la generacion
	for key in keys:
		if prev_key == key:
			schedule.append({"delay": key, "args":_enemy_spawn_schedule[key]})
		else:
			schedule.append({"delay": key - prev_key, "args":_enemy_spawn_schedule[key]})
		prev_key = key
	$Timer.wait_time = schedule[0]["delay"]
	_enemy_spawn_schedule = schedule
	$Timer.start()

func add_to_enemy_schedule(spawn_time, path_index, duration, trans_type, ease_type, delay):
	"""Añade un nuevo enemigo a la lista de enemigos a spawnear"""
	if _enemy_spawn_schedule.has(spawn_time):
		_enemy_spawn_schedule[spawn_time].append([path_index, duration, trans_type, ease_type, delay])
	else:
		_enemy_spawn_schedule[spawn_time] = [[path_index, duration, trans_type, ease_type, delay]]
		$Timer.wait_time = spawn_time

func spawn_enemie(path_index, duration, trans_type, ease_type, delay):
	"""Crea un enemigo en un camino y hace que recorra el camino con ciertos parametros"""
	var path = paths[path_index]
	#el camino en el cual se creara el enemigo
	var rail = Rail.instance()
	var enemy = Dummy.instance()
	var tween = rail.get_node("Tween")
	#un objeto que permite al enemigo moverse por el camino
	#rail.set_enemie(enemy)
	rail.add_child(enemy)
	path.add_child(rail)
	tween.interpolate_property(rail, "unit_offset", 0, 1, duration, trans_type, ease_type, delay)
	#tween se encarga de mover un enemigo por un camino
	enemy.connect("enemie_deleted", self, "_on_enemie_deleted")
	#Hace que el enemigo llame a la funcion _on_enemie_deleted cuando sea eliminado
	tween.start()
	#inicia el movimiento
	print("Enemie @", enemy.get_instance_id(), " Spawned")
	_enemie_counter += 1

func _on_enemie_deleted():
	print("Removed enemie from wave")
	if _enemy_spawn_schedule.empty() and _enemie_counter == 1:
		emit_signal("wave_ended")
		print("Wave ended")
	else:
		_enemie_counter -= 1

func _on_Timer_timeout():
	var current = _enemy_spawn_schedule.pop_front()
	#Obtiene la informacion sobre los siguientes enemigos a ser generados
	for arg in current["args"]:
		#Generar los enemigos
		self.callv("spawn_enemie", arg)
	if _enemy_spawn_schedule.empty():
	# Si son los ultimos enemigos de la lista
		$Timer.stop()
		print("All enemies spawned")
		return
	$Timer.wait_time = _enemy_spawn_schedule[0]["delay"]
	#Obtener el tiempo de retraso del los siguentes enemigos a ser generados
	$Timer.start()
