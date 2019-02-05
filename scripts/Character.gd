extends "res://scripts/Hittable.gd"

var healt_points = 1
export (bool) var is_able_to_shoot = true 

onready var Bullet = preload("res://scenes/Bullet.tscn")
onready var Laser = preload("res://scenes/Laser.tscn")
onready var ShootPaterns = preload("res://scripts/ShootPatterns.gd") 

onready var ShootContainer = get_node("ShootContainer")
# Almacena como nodos hijos a los laseres y ballas que el personaje utiliza

func shoot():
	pass

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.add_to_group(GlobalScript.CHARACTER_GROUP)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
