extends Node

var _body
var body setget set_body, get_body
var item_type setget , get_item_type
var sprite setget set_sprite, get_sprite
var hitbox setget set_hitbox, get_hitbox
var auto_use 

func _init(auto_use=false, follow=null):
	var Body = load("res://scripts/ItemBody.gd")
	self._body = Body.new()
	self._body.connect("item_captured", self, "_captured")
	self.add_to_group(GlobalScript.ITEMS_GROUP)
	self.auto_use = auto_use
	#self.add_child(_body)

func _captured(cacher):
	#self.remove_child(_body)
	_body.queue_free()
	cacher.add_item(self)

func get_body():
	return _body

func set_body(b):
	_body = b

func get_item_type():
	return item_type

func get_sprite():
	if _body == null:
		return null
	return _body._Sprite

func set_sprite(sprite):
	if _body != null:
		_body._Sprite = sprite

func get_hitbox():
	if _body == null:
		return null
	return _body._Hitbox

func set_hitbox(hitbox):
	if _body != null:
		_body._Hitbox = hitbox

func use(affected):
	pass