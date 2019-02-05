extends "res://scripts/Enemy.gd"
# ENEMIGO DE PRUEBAS

var frames_after_last_bullet = 0
var t = 0.0

func _ready():
# _ready() de enemy se llama automaticamente 
	pass

func shoot():
	var new_bullet = Bullet.instance()
	#Verifica si existe algun nodo laser dentro de shootContainer
	if not ShootContainer.has_node("Laser"):
		var laser = Laser.instance()
		laser.position = self.position
		laser.set_affected_group(GlobalScript.PLAYER_GROUP)
		laser.rotate(GlobalScript.HALF_PI)
		laser.set_length(300)
		laser.set_lifetime(3)
		ShootContainer.add_child(laser)
	new_bullet.position = self.position
	new_bullet.set_lifetime(0)
	new_bullet.set_affected_group(GlobalScript.PLAYER_GROUP)
	#new_bullet.add_to_schedule(10.0, "linear_uniform", [GlobalScript.QUARTER_PI, 8.0])
	new_bullet.add_to_schedule(0, "linear_uniform", [GlobalScript.HALF_PI, 10], false)
	ShootContainer.add_child(new_bullet)

func _process(delta):
	if is_able_to_shoot and frames_after_last_bullet >= 24:
		frames_after_last_bullet = 1
		shoot()
	else:
		frames_after_last_bullet += 1
	t += 0.5
