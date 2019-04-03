extends "res://scripts/Player.gd"
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frame_counter = 0
var frames_afther_last_bullet = 0
var _AnimationPlayer = null

# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	# _ready() de player.gd se llama automaticamente
	focused_speed = 100
	normal_speed = 500
	current_speed = normal_speed
	_AnimationPlayer = $Sprite/AnimationPlayer
	_AnimationPlayer.play("Normal")

func _spell():
	if _Spell.in_spell or _Spell.in_cooldown() or not _Spell.enable_spell_use:
		return
	var name 
	if focus:
		name = "patuchol_flare"
	else:
		name = "radiotherapy"
	_Spell.start_spell(name)

func _shoot():
	var new_bullet = DeffaultShoots.bullet_a(self.global_position, GlobalScript.ENEMIES_GROUP, -GlobalScript.HALF_PI, 300)
	ShootContainer.add_child(new_bullet)
	new_bullet = DeffaultShoots.bullet_b(self.global_position, GlobalScript.ENEMIES_GROUP, -GlobalScript.HALF_PI, 300, -3)
	ShootContainer.add_child(new_bullet)

# Called every frame. Delta is time since last frame.
# Update game logic here.
func _process(delta):
	var state = null
	# ---------------------------- Permite disparar cada 15 frames
	if frames_afther_last_bullet >= 15 and Input.is_action_pressed("player_shoot"):
		_shoot()
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
		#current_speed = FOCUSED_MOVMENT_SPEED
		if Input.is_action_pressed("ui_right"):
			_AnimationPlayer.play("FocusedRigth")
		elif Input.is_action_pressed("ui_left"):
			_AnimationPlayer.play("FocusedLeft")
		else:
			_AnimationPlayer.play("Focused")
	else:
		$Hitbox/HitboxSprite.hide()
		#current_speed = NORMAL_MOVMENT_SPEED
		if Input.is_action_pressed("ui_right"):
			_AnimationPlayer.play("Rigth")
		elif Input.is_action_pressed("ui_left"):
			_AnimationPlayer.play("Left")
		else:
			_AnimationPlayer.play("Normal")
	#update_position(current_speed, delta)

