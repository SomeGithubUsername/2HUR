extends Node

onready var Dummy = preload("res://scenes/enemies/Dummy.tscn")
# Se usa para spawnear enemigos

# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	$Timer.start()
	$Timer.one_shot = false
	randomize()

# Called every frame. Delta is time since last frame.
# Update game logic here.
func _process(delta):
	pass

func spawn_enemie():
	var new_enemy = Dummy.instance()
	var path_name = "Path"+String(randi()%7)
	var path = get_node("Paths/" + path_name)
	var follow = get_node("Paths/" + path_name + "/PathFollow")
	var tween = Tween.new()
	path.add_child(tween)
	follow.add_child(new_enemy)
	tween.interpolate_property(follow, "unit_offset", 0, 1, 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	# Ajusta la propiedad unit_offset de follow de 0 a 1 en 4 segundos de una manera lineal del inicio hasta fin con un retraso inicial de 0.5 segundos     
	tween.set_repeat(false)
	tween.start()
	print("Enemie @", new_enemy.get_instance_id()," spawned in path: ", path_name) 

func _on_Timer_timeout():
	spawn_enemie()
	$Timer.wait_time = 5
	$Timer.start()
