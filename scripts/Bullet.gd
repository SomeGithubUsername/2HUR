extends "res://scripts/Shoot.gd"

var t = 0.0
var radius = 0
var velocity = Vector2(0.0, 0.0)
var velocity_func = null
var schedule = []
var current_schedule_index = 0 

onready var ShootPaterns = preload("res://scripts/ShootPatterns.gd")

func _ready():
	# velocity_func = funcref(self, "sin_pattern")
	# Referencia a la funcion self.spiral_pattern()
	pass

func set_scale(s):
	if s <= 0:
		return
	self.scale *= s

func set_initial_position(pos):
	self.position = pos

func set_lifetime(seconds):
	if seconds == 0:
		$LifeTimer.stop()
		return 
	$LifeTimer.wait_time = seconds
	$LifeTimer.start()

# Schedule es una tabla que contiene un tiempo, el nombre de un patron de movimiento y los parametros del patron
# si el tiempo actual es mayor o igual cambiara al siguente patron de movimiento
func add_to_schedule(time, pattern, args):
	schedule.append({"time":time, "pattern":pattern, "args":args})

func _process(delta):
	var current_schedule = schedule[current_schedule_index]
	var args = current_schedule["args"]
	velocity_func = funcref(ShootPaterns, current_schedule["pattern"])
	# Aumente current_schedule_index para cambiar el patron de movimiento deacuerdo el tiempo
	if t > current_schedule["time"] and current_schedule_index + 1 < schedule.size():
		current_schedule_index += 1
		# Actualiza las variables
		current_schedule = schedule[current_schedule_index]
		args = current_schedule["args"]
		velocity_func = funcref(ShootPaterns, current_schedule["pattern"])		
	# dpos = v dt
	self.position += velocity
	# Llama a la funcion segun el numero de argumentos
	match args.size():
		0:
			velocity = velocity_func.call_func()
		1:
			velocity = velocity_func.call_func(args[0])
		2:
			velocity = velocity_func.call_func(args[0], args[1])
		3:
			velocity = velocity_func.call_func(args[0], args[1], t)
		4:
			velocity = velocity_func.call_func(args[0], args[1], args[2], t)
		5:
			velocity = velocity_func.call_func(args[0], args[1], args[2], args[3], t)
		6:
			velocity = velocity_func.call_func(args[0], args[1], args[2], args[3], args[4], t)
		_:
			assert(false)
	t += 0.5

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free() # Marca la bala para ser eliminada al salir de la pantalla 
