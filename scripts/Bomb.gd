extends "res://scripts/Item.gd"

func _init():
	._init(false, true)

func use(grabber):
	if grabber.bombs == 3:
		grabber.points += 500
		return
	grabber.bombs += 1