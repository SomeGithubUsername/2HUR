extends Area2D

var angular_velocity = 0.0
var can_erase_bullets = false 
var afected_group = null
var life_time = 0
var damage = 1

func set_affected_group(group_name):
	afected_group = group_name

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# Cuando el temporizador termine eliminar el disparo
func _on_LifeTimer_timeout():
	print("End life time")
	self.hide()
	$Hitbox.disabled = true
	self.queue_free()

func _on_Shoot_area_entered(area):
	if area.get_groups().has(afected_group):
		area.damage(self.damage)
		# print("Hiting ", afected_group)