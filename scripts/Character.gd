extends "res://scripts/Hittable.gd"

var healt_points = 1
export (bool) var is_able_to_shoot = true 

onready var Bullet = preload("res://scenes/shots/Bullet.tscn")
# Permite crear balas genericas
onready var Laser = preload("res://scenes/shots/Laser.tscn")
# Permite crear laseres genericos
onready var ShootPaterns = preload("res://scripts/shots/ShootPatterns.gd") 

onready var ShootContainer = get_node("ShootContainer")
# Almacena como nodos hijos a los laseres y ballas que el personaje utiliza

onready var DeffaultShootsClass = preload("res://scripts/shots/DefaultShoots.gd")
# La escena que se necesita para instanciar la claser

var DeffaultShoots = null

func shoot():
	pass

func _ready():
	DeffaultShoots = DeffaultShootsClass.new()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.add_child(DeffaultShoots)
	self.add_to_group(GlobalScript.CHARACTER_GROUP)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
