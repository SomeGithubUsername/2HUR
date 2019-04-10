extends "res://scripts/Item.gd"

func _init(follow=null):
	._init(true, true, follow)
	self._Sprite.texture = load("res://images/items.png")
	self._Sprite.hframes = 26
	self._Sprite.vframes = 26
	self._Sprite.frame = 156
	self._Hitbox.shape = CircleShape2D.new()
	self._Hitbox.shape.radius = self._Sprite.get_rect().size.x/2
	
func use(grabber):
	#if grabber.lifes > 3:
	#	grabber.points += 200
	#	return
	grabber.lifes += 1