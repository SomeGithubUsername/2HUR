extends "res://scripts/Enemy.gd"
# ENEMIGO DE PRUEBAS

var frames_after_last_bullet = 0
onready var Bullet = preload("res://scenes/Bullet.tscn")
onready var ShootContainer = get_node("ShootContainer")
onready var ShootPaterns = preload("res://scripts/ShootPatterns.gd")
var t = 0.0

func _ready():
# _ready() de enemy se llama automaticamente 
	pass

func shoot():
	var new_bullet = Bullet.instance()
	new_bullet.position = self.position
	new_bullet.set_lifetime(0)
	new_bullet.set_affected_group(GlobalScript.PLAYER_GROUP)
	#new_bullet.add_to_schedule(10.0, "linear_uniform", [GlobalScript.QUARTER_PI, 8.0])
	new_bullet.add_to_schedule(0, "linear_uniform", [GlobalScript.HALF_PI, 10])
	ShootContainer.add_child(new_bullet)

func _process(delta):
	if is_able_to_shoot and frames_after_last_bullet >= 20:
		frames_after_last_bullet = 1
		shoot()
	else:
		frames_after_last_bullet += 1
	t += 0.5
