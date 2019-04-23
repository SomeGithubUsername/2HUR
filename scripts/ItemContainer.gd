extends Node
"""Lleva a cabo el almacenamiento y uso de items"""

var item_count setget , get_item_count
var carrier 
# El objeto al que se le aplicaran los efectos de los items 
var _bag
# Contiene como llaves el tipo de item, como valor una lista con referencias a los items del tipo

func _init(carrier=null):
	self.name = "ItemContainer"
	self._bag = {}
	var parent = self.get_parent()
	if carrier == null and parent != null: 
		self.carrier = carrier

func add_item(item):
	"""Agrega un item, si el item es de uso automatico lo usa y lo elimina"""
	if item.auto_use:
		item.use(self.carrier)
		item.queue_free()
	if self.has_item(item.item_type):
		self._bag[item.item_type].append(item)
	else:
		self._bag[item.item_type] = [item]
	self.add_child(item)

func count_of_type(type):
	"""Cuenta los items del mismo tipo"""
	if self.has_item(type):
		return self._bag[type].size()
	return 0

func get_carrier():
	return carrier

func use_item(type):
	""" Usa un item del tipo especificado y lo elimina, si existe """
	if self.has_item(type):
		var items = self._bag[type]
		var item = items.pop_back()
		#Saca un item de la lista
		self.remove_child(item)
		item.use(self.carrier)
		item.queue_free()
		#Usa el item y lo elimina

func has_item(type):
	"""Verifica si contiene un objeto del tipo especificado"""
	if type in self._bag.keys():
		return not self._bag[type].empty()
	else:
		return false

func get_item_count():
	return self.get_child_count()

func is_empty():
	return self.get_child_count() < 1