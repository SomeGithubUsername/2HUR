extends PathFollow2D
# Esta clase mueve a un enemigo por un caminio(Path2D) con ayuda del tweem

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func on_child_enemie_deleted():
	"""Se llama por una señal que emite un enemigo agregado como nodo hijo al morir"""
	self.queue_free()

#func _process(delta):
#	if ! self.enemie_reference.get_ref():
#		self.queue_free()
