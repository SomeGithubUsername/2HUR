extends "res://scripts/Item.gd"

var points 

func _init(points=100):
	._init(true)
	self.points = points
	self.sprite.texture = load("res://images/PC Computer - Touhou Fuujinroku Mountain of Faith - Objects and Projectiles.png")
	self.sprite.region_enabled = true
	self.sprite.region_rect = Rect2(268, 223, 256, 18)
	self.sprite.hframes = 16
	self.sprite.vframes = 1
	self.sprite.frame = 1
	self.hitbox.shape = RectangleShape2D.new()
	self.hitbox.shape.extents.x = 8
	self.hitbox.shape.extents.y = 8
	self.item_type = "ScorePoint"

func use(cacher):
	#print("Used a life")
	cacher.score += points