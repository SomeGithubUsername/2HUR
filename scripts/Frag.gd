extends "res://scripts/Item.gd"

func _init():
	._init()
	self.sprite.texture = load("res://images/items.png")
	self.sprite.hframes = 26
	self.sprite.vframes = 26
	self.sprite.frame = 158
	self.hitbox.shape = CircleShape2D.new()
	self.hitbox.shape.radius = 10
	self.item_type = "Fragment"

func use(cacher):
	print("Cant be used")