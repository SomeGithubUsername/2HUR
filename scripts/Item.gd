extends Area2D
# Define la clase base para un item

var auto_collect = false
var auto_use = false
var speed = 500
var _effect = null 
var _Sprite = null
var _Hitbox = null
var _follow = null

func _init(auto_collect=false, auto_use=false, follow=null):
	"""
	auto_colect: Indica si el item se mueve hacia el jugador
	auto_use: Inica si el effecto del item se usa automaticamente al ser recolectado. Ejemplo: Vidas, Puntos ...
	follow: Especifica el objeto a segir, si auto_colect es false se ignorar
	"""
	self.auto_collect = auto_collect
	if auto_collect:
		self._follow = follow
	self.auto_use = auto_use
	self.connect("area_entered", self, "_item_captured")
	self._Sprite = Sprite.new()
	self._Hitbox = CollisionShape2D.new()
	self.add_child(self._Sprite)
	self.add_child(self._Hitbox)

func _ready():
	self.set_process(true)

func _process(delta):
	var vel = Vector2()
	if self.auto_collect:
		var theta = get_angle_to(self._follow.position)
		vel.x = self.speed*cos(theta)
		vel.y = self.speed*sin(theta)
	else:
		vel.x = 0
		vel.y = 100
	self.position += delta*vel

func use(affected):
	pass

func _item_captured(grabber):
	"""Se llama cuando el objeto es capturado por el jugador"""
	if grabber.is_in_group(GlobalScript.PLAYER_GROUP):
		if auto_use:
			self.use(grabber)
			self.queue_free()
		else:
			grabber.add_item(self)
		self.set_process(false)

