extends Node

func _ready():
	var Score = load("res://scripts/items/ScorePoint.gd")
	var Life = load("res://scripts/items/Life.gd")
	var Bomb = load("res://scripts/items/Bomb.gd")
	var Power = load("res://scripts/items/Power.gd")
	var item = null
	var inc = 10
	for It in [Score, Life, Bomb, Power]:
		item = It.new()
		item._body.position.x = 120 + 2*inc
		item._body.position.y = 10
		item._body.speed = 60 - inc
		inc += 4
		self.add_child(item._body)