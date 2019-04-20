extends "res://scripts/Character.gd"
var screen_size # Guarda los limites de movimiento del jugador
var graze_points = 0
var lifes = 1 setget , get_lifes
var bombs = 1 setget , get_bombs
var focus = false setget , is_focused
var power = 0
var current_speed = 0
var focused_speed = 200
var normal_speed = 400
var points = 0
var _bag = null
var _Spell = null
var _ItemContainer = null

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
		var use_item = _ItemContainer.get_child_count() > 0 and Input.is_action_just_pressed("player_use_item_1")
		if use_item:
			var item = _ItemContainer.get_child(0)
			use_item(item.item_type)

func get_lifes():
	return lifes

func get_bombs():
	return bombs

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
	position.x = clamp(position.x, 0.0, screen_size.x)
	position.y = clamp(position.y, 0.0, screen_size.y)

# Regresa verdadero si el jugador esta en modo focus
func is_focused():
	return focus

func damage(damage_points):
	"""Heredada, lleva a cabo el control del daño"""
	print("The player was hitted")

func _init():
	var SM = load("res://scripts/SpellcardManager.gd")
	#self._Spell = SM.new(self, GlobalScript.ENEMIES_GROUP, $ShootContainer)
	#self.add_child(_Spell)
	self._bag = {}
	# Conitene el tipo de item y la cantidad {"LifeFragment": 6, "BombFragment":3, ...}

func _ready():
	._ready()
	self.add_to_group(GlobalScript.PLAYER_GROUP)
	self._ItemContainer = $ItemContainer
	screen_size = get_viewport().size
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
		print("Adding item: ", item.item_type)
		if item.auto_use:
			# Si el objeto es de uso inmediato, se usa y se elmimina
			item.use(self)
			item.queue_free()
		else:
			# Si no, se agrega a la bolsa
			var item_type = item.item_type
			if item_type in self._bag.keys():
				# Si el jugador tiene un objeto del mismo tipo
				self._bag[item_type] += 1
				# Aumentar el contador del objeto
			else:
				self._bag[item_type] = 1
				self._ItemContainer.add_child(item)
		print("Bag: ", self._bag)

func use_item(item_type):
	"""Utiliza el item del tipo especificado"""
	if item_type in self._bag.keys():
		self._bag[item_type] -= 1
		assert(self._bag[item_type] >= 0)
		var item = null
		for it in self._ItemContainer.get_children():
			#Busca el item que tenga el mismo tipo que el especificado
			if item_type == it.item_type:
				item = it
				break
		assert(item != null)
		item.use(self)
		# Aplica el efecto del objeto sobre el jugador
		if self._bag[item_type] < 1:
			# Si es el ultimo item
			self._bag.erase(item_type)
			self._ItemContainer.remove_child(item)
			item.queue_free()
			# Eliminar el item
		else:
			self._bag[item_type] -= 1

func _on_GrazeArea_area_exited(area):
	# Si el area que salio de GrazeArea es una bala
	if area.is_in_group(GlobalScript.BULLETS_GROUP):
		# Si la bala daña al jugador
		if area.afected_group == GlobalScript.PLAYER_GROUP:
			self.graze_points += 1
			#print("Graze Points: ", self.graze_points)