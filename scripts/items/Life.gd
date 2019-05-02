extends "res://scripts/items/Item.gd"

func _init():
	._init(true)
	self.sprite.texture = load("res://images/PC Computer - Touhou Fuujinroku Mountain of Faith - Objects and Projectiles.png")
	self.sprite.region_enabled = true
	self.sprite.region_rect = Rect2(268, 223, 256, 18)
	self.sprite.hframes = 16
	self.sprite.vframes = 1
	self.sprite.frame = 6
	self.hitbox.shape = CircleShape2D.new()
	self.hitbox.shape.radius = 10
	self.item_type = "Life"

func use(cacher):
	#print("Used a life")
	cacher.lifes += 1