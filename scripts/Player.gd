extends "res://scripts/Character.gd"
var screen_size # Guarda los limites de movimiento del jugador
var focus = false
var power = 0

# Actualiza la posicion del jugador
func update_position(speed, delta):
	var velocity_vector = Vector2(0.0, 0.0)
	# ------------------------------ Determina la direccion del vector velocidad
	if Input.is_action_pressed("ui_left"):
		velocity_vector.x = -1.0
	elif Input.is_action_pressed("ui_right"):
		velocity_vector.x = 1.0
	if Input.is_action_pressed("ui_up"):
		velocity_vector.y = -1.0
	elif Input.is_action_pressed("ui_down"):
		velocity_vector.y = 1.0
	# ----------------------------- Ajusta la norma del vector velocidad
	velocity_vector = velocity_vector.normalized() * speed
	position += velocity_vector * delta # Actualiza la posicion
	# ----------------------------- Evita que el jugador salga de la pantalla	
	position.x = clamp(position.x, 0.0, screen_size.x)
	position.y = clamp(position.y, 0.0, screen_size.y)

# Regresa verdadero si el jugador esta en modo focus
func is_focused():
	focus = (focus != Input.is_action_just_pressed("player_change_mode"))
	"""
	Equivalentes
	focus = focus XOR Input.is_action_just_pressed("focus")
	
	if Input.is_action_just_pressed("focus"):
		focus = not focus
	"""
	return focus

func damage(damage_points):
	print("The player was hitted")

func _ready():
	self.add_to_group(GlobalScript.PLAYER_GROUP)
	screen_size = get_viewport().size

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

