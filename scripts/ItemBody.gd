extends Area2D
"""
Realiza las funciones en pantalla de un item (moverse, detectar la colision y seguir al jugador), 
se elimina cuando el item es capturado por el jugador
"""

var _Sprite = null
var _Hitbox = null
var _follow = null
var _vel = null
var _soul = null
var speed = 100

signal item_captured(cacher)

func _init(follow=null):
	_Sprite = Sprite.new()
	_Hitbox = CollisionShape2D.new()
	_follow = follow
	_vel = Vector2(0.0, 0.0)
	self.add_child(_Sprite)
	self.add_child(_Hitbox)

func _ready():
	self.connect("area_entered", self, "_item_captured")

func _item_captured(cacher):
	if cacher.is_in_group(GlobalScript.PLAYER_GROUP):
		emit_signal("item_captured", cacher)

func _process(delta):
	if _follow == null:
		_vel.x = 0.0
		_vel.y = speed
	else:
		var angle_to_target = self.position.angle_to( _follow.position )
		_vel.x = speed*cos(angle_to_target)
		_vel.y = speed*sin(angle_to_target)
	self.position += _vel*delta