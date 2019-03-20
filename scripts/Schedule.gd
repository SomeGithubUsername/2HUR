extends Node

class ScheduleStop:
	"""Similar a una parada de autobus"""
	var _objs = []
	# Que objeto contiene la funcion
	var _func_names = []
	# Nombre de la funcion a la cual llamar
	var _args = []
	# Argumentos para la funcion en forma de un arreglo
	func _init(time):
		pass
	
	func add_func(obj, func_name, args):
		assert( typeof(args) == TYPE_ARRAY )
		self._func_names.append(func_name)
		self._objs.append(obj)
		self._args.append(args)
	
	func execute():
		"""Ejecuta todas las funciones marcadas para el tiempo"""
		assert(_objs.size() == _func_names.size() and _args.size() == _func_names.size())
		for i in range(_objs.size()):
			_objs[i].callv(_func_names[i], _args[i])

class Schedule: 
	var _stops = {}
	var _times = []
	
	func _init():
		pass
	
	func add_stop(time, obj, func_name, args):
		if not _stops.has(time):
			_stops[time] = ScheduleStop.new()
			_times.append(_times)
			_times.sort() # Solucion temporal
		_stops[time].add_func(obj, time, args)
	
	func get_next_delay():
		"""Obtiene los segundos de retraso entre la siguiente parada y la parada actual"""
		if _times.size() > 2:
			return _times[1] - times[0]
		else:
			# En caso de la parada actual sea la ultima
			return 0
	
	func execute_next():
		""" Ejecuta las funciones de la siguente parada y la remueve de la lista, en caso de estar vacia regresa false"""
		if _times.empty():
			return false
		time = _times.pop_front()
		_stops[time].execute()
		return true