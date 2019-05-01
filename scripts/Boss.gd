extends "res://scripts/Enemy.gd"
"""Clase base para los jefes """

signal life_bar_ended

var _ItemContainer
var total_healt setget , get_total_healt
var spell_count setget , count_spells
var _spells
# Un diccionario que almacena informacion sobre los spells
var _current_spell
# El nombre del spell que se esta ejecutando 
var _stage

func _init():
	._init()
	_ItemContainer = get_node("ItemContainer")
	_load_next_spell()
	set_process(false)

func _ready():
	_stage = self.get_parent()
	connect("life_bar_ended", self, "_load_next_spell")
	set_process(true)

func damage(damage_points):
	healt_points -= damage_points
	if healt_points <= 0:
		emit_signal("life_bar_ended")

func get_total_healt():
	var hp = 0
	for s in self._spells.values():
		hp += s["healt"]
	return hp

func add_spell(spell_name, healt, items_to_drop=null):
	"""
	Agrega un spell a la lista de spells,
	spell_name: el nombre del spell que se usara
	healt: la salud que tendra el jefe durante el spell
	items_to_drop: un dicionario NombreObejto: CantidadASoltar, o null
	"""
	if spell_name in self._spells.keys():
		return
	self._spells[spell_name] = {"healt":healt, "drop":items_to_drop}

func count_spells():
	return self._spells.size()

func _drop_items():
	"""
	Se llama cada vez que una barra de vida es agotada, suelta items en el stage
	deacuerdo a el spell que se haya ejecutado
	"""
	_ItemContainer.drop_all(_stage)

func _load_next_spell():
	"""Carga la informacion del siguiente spell y lo elimina de la lista"""
	_drop_items()
	if _spells.empty():
		_boss_killed()
		return
	var names = _spells.keys()
	_current_spell = names[0]
	var spell = _spells[_current_spell]
	healt_points = spell["healt"]
	var drop = spell["drop"]
	if not(drop == null or drop.empty()):
		_ItemContainer.add_items(drop)
	_spells.erase(_current_spell)

func _boss_killed():
	emit_signal("enemie_deleted")
	self.queue_free()
