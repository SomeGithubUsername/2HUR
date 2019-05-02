extends "res://scripts/Character.gd"

# Enviada cuando el enemigo esta apunto de ser eliminado
signal enemie_deleted

func _ready():
	# Called when the node is added to the scene for the first time.
	var parent = self.get_parent()
	assert(parent != null)
	self.add_to_group(GlobalScript.ENEMIES_GROUP)
	self.connect("enemie_deleted", parent, "on_child_enemie_deleted")
	#Conecta la señal para avisar a el nodo padre (rail) en el que se encuentra el enemigo que este esta siendo eliminado

func damage(damage_points):
	"""Heredada de hitable, se encarga del daño"""
	print("Enemy hitted")
	self._delete_process()

func get_main_group():
	return GlobalScript.ENEMIES_GROUP

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_VisibilityNotifier_screen_exited():
	"""Se llama cuando el enemigo deja de ser visible"""
	print("Enemie @", self.get_instance_id(), " deleted")
	self._delete_process()

func _delete_process():
	"""Emite la señal y marca el enemigo para ser eliminado"""
	self.emit_signal("enemie_deleted")
	self.queue_free()
