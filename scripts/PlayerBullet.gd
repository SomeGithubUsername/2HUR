extends "res://scripts/Bullet.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_PlayerBullet_area_entered(area):
	#print("player_bullet_has_entered_an_area")
	if area.get_groups().has("enemies"): # Si el area a la que la bala entro es un enemigo
		print("enemy_hitted")