extends Node

onready var Dummy = preload("res://scenes/Dummy.tscn")
onready var Rail = preload("res://scenes/Rail.tscn")

var paths = []

func _ready():
	paths = $Paths.get_children()
	assert(paths.size() > 0)
	#un array con todos los caminos
	$Timer.wait_time = 2
	$Timer.start()
	#se utiliza para manejar el tiempo en el cual crear enemigos

#func _process(delta):
#	if $Timer.time_left == 0:
#		$Timer.stop()


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

func _on_Timer_timeout():
	print("Enemie Spawned")
	spawn_enemie(0, 4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	$Timer.wait_time = 1
	$Timer.start()
