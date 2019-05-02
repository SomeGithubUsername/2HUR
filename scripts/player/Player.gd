extends "res://scripts/Character.gd"

var _screen_size # Guarda los limites de movimiento del jugador
var graze_points = 0 setget set_graze_points, get_graze_points
var lifes = 1 setget set_lifes, get_lifes
var bombs = 1 setget set_bombs, get_bombs
var power_points = 0 setget set_power_points, get_power_points
var score = 0 setget set_score, get_score
var current_speed = 0 
var focus = false setget , is_focused
var focused_speed = 200
var normal_speed = 400
var _Spell = null
var _ItemContainer = null

const MAX_LIFES = 5
const MAX_BOMBS = 5
const MAX_POWER_POINTS = 10000
const MAX_SCORE = 90000000 # 90 millones
const MAX_GRAZE_POINTS = 8000000

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
		
		if Input.is_action_just_pressed("player_use_bomb"):
			_spell()
			return
		var use_item = (not _ItemContainer.is_empty()) and Input.is_action_just_pressed("player_use_item_1")
		if use_item:
			var item = _ItemContainer.get_child(0)
			_use_item(item.item_type)

func set_graze_points(points):
	graze_points = clamp(graze_points + points, 0, MAX_GRAZE_POINTS) 

func get_graze_points():
	return graze_points

func is_full_power():
	return power_points == MAX_POWER_POINTS

func get_power_points():
	return power_points

func set_power_points(points):
	power_points = clamp(power_points + points, 0, MAX_POWER_POINTS)

func get_score():
	return score

func set_score(new_score):
	score = clamp(score + new_score, 1, MAX_SCORE)

func get_lifes():
	return lifes

func set_lifes(life):
	lifes = clamp(lifes + life, 0, MAX_LIFES)

func get_bombs():
	return bombs

func set_bombs(bomb):
	bombs = clamp(bombs + bomb, 0, MAX_BOMBS)

func _spell():
	pass

# Actualiza la posicion del jugador
func _update_position(delta):
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
	position.x = clamp(position.x, 0.0, _screen_size.x)
	position.y = clamp(position.y, 0.0, _screen_size.y)

# Regresa verdadero si el jugador esta en modo focus
func is_focused():
	return focus

func damage(damage_points):
	"""Heredada, lleva a cabo el control del daño"""
	print("The player was hitted")

func _init():
	var SM = load("res://scripts/spells/SpellcardManager.gd")
	self._Spell = SM.new(self, GlobalScript.ENEMIES_GROUP, $ShootContainer)
	self.add_child(_Spell)

func _ready():
	._ready()
	self.add_to_group(GlobalScript.PLAYER_GROUP)
	self._ItemContainer = $ItemContainer
	self._ItemContainer.carrier = self
	_screen_size = get_viewport().size
	focused_speed = 100
	normal_speed = 400
	self.current_speed = normal_speed

func _process(delta):
	._process(delta) #Llamada a la funcion pocess de super
	self._update_position(delta)

func get_main_group():
	return GlobalScript.PLAYER_GROUP

func add_item(item):
	"""Agrega un item a la lista de items del jugador"""
	if item.is_in_group(GlobalScript.ITEMS_GROUP):
		_ItemContainer.add_item(item)

func _use_item(item_type):
	"""Utiliza el item del tipo especificado"""
	_ItemContainer.use_item(item_type)

func _on_GrazeArea_area_exited(area):
	# Si el area que salio de GrazeArea es una bala
	if area.is_in_group(GlobalScript.BULLETS_GROUP):
		# Si la bala daña al jugador
		if area.afected_group == GlobalScript.PLAYER_GROUP:
			self.graze_points += 1
			#print("Graze Points: ", self.graze_points)