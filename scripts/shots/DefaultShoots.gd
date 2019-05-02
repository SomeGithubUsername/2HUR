extends Node

var Laser = preload("res://scenes/shots/Laser.tscn")
var Bullet = preload("res://scenes/shots/Bullet.tscn")

func _ready():
	set_process(false)

func bullet_a(position, affected_group, angle, speed):
	"""Crea una bala con un movimiento lineal uniforme"""
	var bullet = Bullet.instance()
	bullet.global_position = position
	bullet.angular_velocity = 0.0
	bullet.set_affected_group(affected_group)
	bullet.add_to_schedule(0, "linear_uniform", [angle, speed], false)
	return bullet

func bullet_b(position, affected_group, angle, initial_speed, aceleration):
	"""Crea una bala con un movimiento lineal acelerado"""
	var bullet = Bullet.instance()
	bullet.global_position = position
	bullet.angular_velocity = 0.0
	bullet.set_affected_group(affected_group)
	bullet.add_to_schedule(0, "linear_acelerated", [angle, initial_speed, aceleration], true)
	return bullet

func laser_a(position, affected_group, angle, length, life_time):
	"""Crea un laser fijo"""
	var laser = Laser.instance()
	laser.set_affected_group(affected_group)
	laser.global_position = position
	laser.angular_velocity = 0.0
	laser.rotate(angle)
	laser.set_length(length)
	laser.set_lifetime(life_time)
	return laser