extends "res://scripts/Character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	self.add_to_group(GlobalScript.ENEMIES_GROUP)

func damage(damage_points):
	print("Enemy hitted")

func get_main_group():
	return GlobalScript.ENEMIES_GROUP

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_VisibilityNotifier_screen_exited():
	print("Enemie @", self.get_instance_id(), " deleted")
	self.queue_free()
