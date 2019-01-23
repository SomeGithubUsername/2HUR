extends "res://scripts/PlayerBullet.gd"

var frame_count = 0
var speed = 123
var velocity = Vector2(0.0, 0.0)
# Called when the node is added to the scene for the first time.
# Initialization here
func _ready():
	self.add_to_group("player_bullets")
	$Sprite.frame = 72

func start_at(angle, speed, pos):
	self.position = pos
	self.velocity.x = speed * cos(angle)
	self.velocity.y = speed * sin(angle)

func _process(delta):
	self.position += self.velocity * delta
	if frame_count == 60:
		frame_count = 1
	else:
		frame_count += 1
	if frame_count & 7 != 7:
		return 
	if $Sprite.frame == 79:
		$Sprite.frame = 72
	else:
		$Sprite.frame += 1

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free() # Marca la bala para ser eliminada cuando sale de la pantalla
