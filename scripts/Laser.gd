extends "res://scripts/Shoot.gd"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.add_to_group(GlobalScript.LASERS_GROUP)
	#print("new laser")

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if self.angular_velocity != 0.0:
		self.rotate(self.angular_velocity)

func set_length(l):
	var a = $Hitbox.get_shape().a #El punto de inicio de la hitbox 
	var b = $Hitbox.get_shape().b #El pinto final
	var l0 = a.distance_to(b)
	self.scale.x = l/l0 
	#El factor al que se escala la base del rectangulo (paralela al eje x) que contiene a Laser