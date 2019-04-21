extends "res://scripts/Item.gd"

func _init():
	._init(true)
	self.sprite.texture = load("res://images/items.png")
	self.sprite.hframes = 26
	self.sprite.vframes = 26
	self.sprite.frame = 156
	self.hitbox.shape = CircleShape2D.new()
	self.hitbox.shape.radius = 10
	self.item_type = "Life"

func use(cacher):
	print("Used a life")
	cacher.lifes += 1