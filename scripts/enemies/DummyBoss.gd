extends "res://scripts/enemies/Boss.gd"

func _init():
	._init()
	self.add_spell("test", 500, {"Life":1, "Score":12, "Power":3})
	self.add_spell("test2", 500, {"Life":1, "Score":12, "Power":3})