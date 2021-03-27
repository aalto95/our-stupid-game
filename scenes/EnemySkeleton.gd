extends KinematicBody2D

onready var Player = preload("./Player.gd").new()

const TARGET_FPS = 60
const ACCELERATION = 8
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140
var SPEED = 30
var HP = 30
var motion = Vector2.ZERO


func _physics_process(delta):
	
	#motion.x = SPEED
	motion.y += GRAVITY
	
	$AnimationPlayer.play("attack")
	$AnimatedSprite.play("attack")
	
	motion = move_and_slide(motion, Vector2.UP)

func handle_hit():
	HP -= 10
	$AnimatedSprite.play("hit")
	print("Skeleton was hit!")
	if HP <= 0:
		$AnimationPlayer.stop()
		
	
func _on_AxeHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
