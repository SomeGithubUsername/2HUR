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
	var Score = load("res://scripts/ScorePoint.gd")
	var Life = load("res://scripts/Life.gd")
	var Bomb = load("res://scripts/Bomb.gd")
	var Power = load("res://scripts/Power.gd")
	var item = null
	var inc = 10
	for It in [Score, Life, Bomb, Power]:
		item = It.new()
		item._body.position.x = 120 + 2*inc
		item._body.position.y = 10
		item._body.speed = 60 - inc
		inc += 4
		self.add_child(item._body)