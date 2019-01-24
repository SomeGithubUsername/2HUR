extends "res://scripts/Shoot.gd"

var theta = 0.0
var radius = 0
var velocity = Vector2(0.0, 0.0)
var aceleration = Vector2(0.0, 0.0)
var velocity_func = null
var aceleration_func = null

func _ready():
	velocity_func = funcref(self, "circular_func")
	# Referencia a la funcion self.circular_func()

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
	if theta >= TAU:
		theta -= TAU
	else:
		theta += 0.2

func circular_func(t):
	var w = 2.0
	var speed = 50
	var radius = 10
	self.velocity.x = t - radius*w*cos(w*t)
	self.velocity.y = t + radius*w*sin(w*t)
	self.velocity *= speed

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free() # Marca la bala para ser eliminada al salir de la pantalla 
