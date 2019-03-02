extends Node
signal spellcard_ended

var _spellcard_data = []
var _frame_counter = 0
# Un arreglo que almacena datos de las spellcards

func load_spellcard_data():
	pass

func _ready():
	var character = get_node("../")
	self.set_process(false)

func _process(delta):
	_frame_counter += 1

func start():
	self.set_process(true)