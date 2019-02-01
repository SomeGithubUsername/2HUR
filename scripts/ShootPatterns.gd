extends Node
# Contiene patrones de movimiento para disparos, generalmente balas
# Las funciones actualizan la velocidad del disparo en funcion de un parametro(t)
# Las funciones que no requieren el parametro regresan una velocidad constante

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():
#	# Called when the node is added to the scene for the first time.
#	# Initialization here
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# w : Velocidad angular
# t : Tiempo
# s : Desfase

# Movimiento en linea recta con velocidad constante
static func linear_uniform(angle, speed): 
	return Vector2(speed*cos(angle), speed*sin(angle))

# Movimiento en linea retcta acelerado
static func linear_acelerated(angle, initial_speed, aceleration, t):
	var vel = Vector2(0.0, 0.0)
	var v_at = initial_speed + aceleration*t
	vel.x = v_at*cos(angle)
	vel.y = v_at*sin(angle)
	return vel

# Grio en una direccion circular, el punto en el que se encuentre la bala estara en la circunferencia
static func circular(radius, w, s, t):
	var wt = w*t
	var wt_s = wt + s
	var wr = w*radius
	return Vector2(-wr*sin(wt_s), wr*cos(wt_s))

# Una espiral similar a un resorte 2D
static func spiral(angle, speed, radius, w, s, t):
	var v = linear_uniform(angle, speed)
	v += circular(radius, w, s, t)
	return v

# Uma esprial creciente desde el punto inicial
static func centric_spiral(a, w, s, t):
	var wt = w*t
	var wt_s = wt + s
	var sin_wt_s = sin(wt_s)
	var cos_wt_s = cos(wt_s)
	var x = a*(cos_wt_s - wt*sin_wt_s)
	var y = a*(sin_wt_s + wt*cos_wt_s)
	return Vector2(x, y)

# https://en.wikipedia.org/wiki/Hypotrochoid
static func hypotrochoid(r1, r2, d, w, s, t):
	var a = r1 - r2
	var aw = a*w
	var b = aw/r2
	var bd = b*d
	var wt = w*t
	var wts = wt + s
	var bts = b*t + s
	var x = aw*cos(wts) - bd*cos(bts)
	var y = -aw*sin(wts) - bd*sin(bts)
	return Vector2(x, y)
