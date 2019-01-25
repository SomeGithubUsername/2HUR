extends "res://scripts/Shoot.gd"

var theta = 0.0
var radius = 0
var velocity = Vector2(0.0, 0.0)
var aceleration = Vector2(0.0, 0.0)
var velocity_func = null
var aceleration_func = null

func _ready():
	velocity_func = funcref(self, "sin_pattern")
	# Referencia a la funcion self.spiral_pattern()

func start(pos, angle):
	self.position = pos
	self.velocity.x = 100*cos(angle) 
	self.velocity.y = 100*sin(angle)

func set_lifetime(seconds):
	if seconds == 0:
		$LifeTimer.stop()
		return 
	$LifeTimer.wait_time = seconds
	$LifeTimer.start()

func _process(delta):
	self.position += velocity * delta
	if velocity_func != null:
		velocity_func.call_func(theta)
#	if theta >= 2*TAU:
#		theta -= 2*TAU
#	else:
	theta += 0.2

func spiral_pattern(t):
	var w = 2.0
	var speed = 50
	var radius = 10
	self.velocity.x = t - radius*w*cos(w*t)
	self.velocity.y = t + radius*w*sin(w*t)
	self.velocity *= speed

func sin_pattern(t):
	var k = 8.4
	var w = 1.5
	var r = 50
	self.velocity.y = pow(sin(w*t), 3.0)
	self.velocity.x = cos(w*t) - pow(cos(w*t),4.0)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free() # Marca la bala para ser eliminada al salir de la pantalla 
