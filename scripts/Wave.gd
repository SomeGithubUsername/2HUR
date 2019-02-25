extends Node

onready var Dummy = preload("res://scenes/Dummy.tscn")
onready var Rail = preload("res://scenes/Rail.tscn")
var paths = []
#Almacena una referencia a los caminios de una oleada
var _enemy_spawn_schedule = {}
#Almacena inforamcion sobre que ripo de enemigo generar a que tiempo
#[retraso_segundos, [[argumentos_enemigo1], [argumentos_enemigo2], ...] ]

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
	$Timer.start()

func add_to_enemy_schedule(spawn_time, path_index, duration, trans_type, ease_type, delay):
	"""Añade un nuevo enemigo a la lista de enemigos a spawnear"""
	_enemy_spawn_schedule.append({"spawn_time":spawn_time, "args":[path_index, duration, trans_type, ease_type, delay]})

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
	tween.start()
	#inicia el movimiento
	print("Enemie @", enemy.get_instance_id(), " Spawned")

func _on_Timer_timeout():
	self.callv("spawn_enemie", _enemy_spawn_schedule[_schedule_index]["args"])
	_schedule_index += 1
	if _schedule_index >= _enemy_spawn_schedule.size():
		# Si todos los enemigos de la lista han sido spawneados
		print("Wave @", self.get_instance_id(), " ended")
		self.emit_signal("wave_ended")
		self.queue_free()
		return
	$Timer.wait_time = _enemy_spawn_schedule[_schedule_index]["spawn_time"]
	$Timer.start()
