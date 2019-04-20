extends Node
"""
func _ready():
	var Life = load("res://scripts/Life.gd")
	var Bomb = load("res://scripts/Bomb.gd")
	var Fragmet = load("res://Fragment.gd")
	var life = Life.new()
	var bomb = Bomb.new()
	var frag = Fragmet.new()
	var x = 50
	for i in [life, bomb, frag]:
		self.add_child(i)
		i.position.x = 240 + x
		i.position.y = 80
		i.speed = 100
		x += 20
"""
func _ready():
	var Life = load("res://scripts/Life.gd")
	var Frag = load("res://scripts/Frag.gd")
	var frag = Frag.new()
	var life = Life.new()
	life._body.position.x = 300
	frag._body.position.x = 200
	frag._body.speed = 80
	add_child(life._body)
	add_child(frag._body)
