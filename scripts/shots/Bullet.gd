extends "res://scripts/shots/Shoot.gd"

var t = 0.0
var radius = 0
var velocity = Vector2(0.0, 0.0)
var schedule = []
var current_schedule_index = 0 

onready var ShootPaterns = preload("res://scripts/shots/ShootPatterns.gd")

func _ready():
	# velocity_func = funcref(self, "sin_pattern")
	# Referencia a la funcion self.spiral_pattern()
	self.add_to_group(GlobalScript.BULLETS_GROUP)

func set_scale(s):
	if s <= 0:
		return
	self.scale *= s

func set_initial_position(pos):
	self.position = pos

# Schedule es una tabla que contiene un tiempo, el nombre de un patron de movimiento y los parametros del patron
# si el tiempo actual es mayor o igual cambiara al siguente patron de movimiento
func add_to_schedule(time, pattern, args, dependet_of_time):
	"""
	time: El tiempo limite hasta el cual se aplicara el patron
	patter: El nombre del patron de movimiento
	args: Argumentos para pasar a la funcion de patron de movimento
	dependet_of_time: Verdadero para las funciones que requieran del parametro t 
	"""
	schedule.append({"time":time, "pattern":pattern, "args":args, "dependet_of_time":dependet_of_time})

func _process(delta):
	var args = null
	var current_schedule = schedule[current_schedule_index]
	if self.angular_velocity != 0:
		self.rotate(self.angular_velocity)
	if current_schedule_index + 1 < schedule.size() and t > current_schedule["time"]:
	# Si el tiempo limite de el patron se ha agotado, pasar al siguente patron
		current_schedule_index += 1
		current_schedule = schedule[current_schedule_index]
	if current_schedule["dependet_of_time"]:
	# Se crea una copia o de lo contrario en cada llamada a process el arreglo de argumentos aumentara de tamaño
	# debido a que se asigna por referencia
	# Si el patron actual requiere del parametro de tiempo agregar t al arreglo de argumentos
		args = current_schedule["args"].duplicate()
		args.append(t)
	else:
		args = current_schedule["args"]
	velocity = ShootPaterns.callv(current_schedule["pattern"], args)
	# Llama a una funcion de ShootPaterns cuyo nombre esta almacenado en current_schedule["pattern"], envia los argumentos como un arreglo
	assert(velocity != null)
	self.position += self.velocity * delta
	t += 1

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free() # Marca la bala para ser eliminada al salir de la pantalla 
