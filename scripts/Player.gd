extends "res://scripts/Character.gd"
var screen_size # Guarda los limites de movimiento del jugador
var graze_points = 0
var focus = false
var power = 0
var current_speed = 0
var focused_speed = 200
var normal_speed = 400

func _input(event):
	"""Lleva a cabo los eventos de entrada: Cambio de modo, movimiento y spells"""
	if event is InputEventKey:
		# Si el evento fue una pulsacion de tecla
		focus = (focus != Input.is_action_just_pressed("player_change_mode"))
		"""
		Cambia el modo del jugador, cambia cada vez que pulsa la tecla, equivalente
		focus = focus XOR Input.is_action_just_pressed("focus")
		"""
		if focus:
			self.current_speed = focused_speed
		else:
			self.current_speed = normal_speed

# Actualiza la posicion del jugador
func update_position(delta):
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
	velocity_vector = velocity_vector.normalized() * current_speed
	position += velocity_vector * delta # Actualiza la posicion
	# ----------------------------- Evita que el jugador salga de la pantalla
	position.x = clamp(position.x, 0.0, screen_size.x)
	position.y = clamp(position.y, 0.0, screen_size.y)

# Regresa verdadero si el jugador esta en modo focus
func is_focused():
	return focus

func damage(damage_points):
	"""Heredada, lleva a cabo el control del daño"""
	print("The player was hitted")

func _ready():
	._ready()
	self.add_to_group(GlobalScript.PLAYER_GROUP)
	screen_size = get_viewport().size
	focused_speed = 100
	normal_speed = 400
	self.current_speed = normal_speed

func _process(delta):
	._process(delta) #Llamada a la funcion pocess de super
	self.update_position(delta)

func get_main_group():
	return GlobalScript.PLAYER_GROUP

func _on_GrazeArea_area_exited(area):
	# Si el area que salio de GrazeArea es una bala
	if area.get_groups().has(GlobalScript.BULLETS_GROUP):
		# Si la bala daña al jugador
		if area.afected_group == GlobalScript.PLAYER_GROUP:
			self.graze_points += 1
			print("Graze Points: ", self.graze_points)