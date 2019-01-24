extends "res://scripts/Hittable.gd"

var healt_points = 1
export (bool) var is_able_to_shoot = true 

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

# Se llama cuando un disparo golpea la hitbox del enemigo, damage_points es el daño del disparo
func damage(damage_points):
	self.healt_points -= damage_points
	if self.healt_points <= 0:
		self.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
