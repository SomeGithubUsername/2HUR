extends "res://scripts/Player.gd"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const SPRITE_ANIMATION_LIMITS = {	"up_or_down":[0, 4],	"focused_up_or_down":[24, 28],
									"right":[8, 15],		"focused_right":[32, 39],
									"left":[16, 23], 		"focused_left":[40, 47]}
const NORMAL_MOVMENT_SPEED = 700
const FOCUSED_MOVMENT_SPEED = 50
onready var Bullet = preload("res://scenes/Bullet.tscn")
onready var ShootContainer = get_node("ShootContainer") # Todas las nuevas balas son agregadas como hijos a este nodo
var frame_counter = 0
var frames_afther_last_bullet = 0

# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	# _ready() de player.gd se llama automaticamente
	pass

func shoot():
#	var new_bullets = [ Bullet.instance(), Bullet.instance(), Bullet.instance() ]
#	ShootContainer.add_child(new_bullets[0])
#	ShootContainer.add_child(new_bullets[1])
#	ShootContainer.add_child(new_bullets[2])
#	new_bullets[0].start_at(-GlobalScript.HALF_PI, 100, self.position)
#	new_bullets[1].start_at(-GlobalScript.QUARTER_PI, 300, self.position)
#	new_bullets[2].start_at(-(GlobalScript.QUARTER_PI + GlobalScript.HALF_PI), 250, self.position)
	var new_bullet = Bullet.instance()
	new_bullet.set_affected_group("enemies")
	new_bullet.start(position, -GlobalScript.HALF_PI)
	new_bullet.set_lifetime(0)
	ShootContainer.add_child(new_bullet)

# Called every frame. Delta is time since last frame.
# Update game logic here.
func _process(delta):
	var state = null
	var current_speed = 0
	# ---------------------------- Permite disparar cada 15 frames
	if frames_afther_last_bullet >= 15 and Input.is_action_pressed("player_shoot"):
		shoot()
		frames_afther_last_bullet = 0
	else:
		frames_afther_last_bullet += 1
	# ---------------------------- Guardan el frame inicial y final del sprite animado
	var intial_sprite_frame = 0
	var final_sprite_frame = 0
	# ---------------------------- Cuenta los frames de 1-60
	if frame_counter == 60:
		frame_counter = 1
	else:
		frame_counter += 1
	# ---------------------------- Cambia la velocidad de movimiento y los limites de la animacion si el jugador cambia de modo
	if is_focused():
		$Hitbox/HitboxSprite.show()
		current_speed = FOCUSED_MOVMENT_SPEED
		if Input.is_action_pressed("ui_right"):
			state = "focused_right"
		elif Input.is_action_pressed("ui_left"):
			state = "focused_left"
		else:
			state = "focused_up_or_down"
	else:
		$Hitbox/HitboxSprite.hide()
		current_speed = NORMAL_MOVMENT_SPEED
		if Input.is_action_pressed("ui_right"):
			state = "right"
		elif Input.is_action_pressed("ui_left"):
			state = "left"
		else:
			state = "up_or_down"
	update_position(current_speed, delta)
	intial_sprite_frame = SPRITE_ANIMATION_LIMITS[state][0]
	final_sprite_frame = SPRITE_ANIMATION_LIMITS[state][1]
	# ------------------------------- Mantiene el frame de la animacion por 7 frames
	if frame_counter & 7 != 7:
	# a & b = a % b + 1 si b = 2^n - 1
		return
	if $Sprite.frame >= final_sprite_frame or $Sprite.frame < intial_sprite_frame:
	# $Sprite es una abreviacion de get_child("Sprite")
		$Sprite.frame = intial_sprite_frame
	else:
		$Sprite.frame += 1
