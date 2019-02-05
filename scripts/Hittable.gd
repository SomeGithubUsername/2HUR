extends Area2D

export (bool) var permanent_invencibility = false
var invencibility = false
var invencibility_frames = 0

func give_invencibility_frames(frames):
	self.invencibility_frames = frames

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.add_to_group(GlobalScript.HITTABLE_GROUP)

func _process(delta):
	if permanent_invencibility or invencibility_frames > 0:
		invencibility_frames -= 1
		invencibility = true
	else:
		invencibility = false

func damage(damage_points):
	pass

func get_main_group():
	pass

# Se llama cada vez que un area entrea en la hitbox
func _on_Hittable_area_entered(area):
	"""Se encarga de manejar el daño de los disparos"""
	if not self.invencibility and area.get_groups().has(GlobalScript.SHOOT_GOUP):
		# Si no es invencible y el area que entro esta en el grupo de los disparos
		if area.afected_group == self.get_main_group():
			# Si el area puede dañar al grupo en el que se encuentra el objeot
			self.damage(area.damage)
