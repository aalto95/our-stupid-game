extends KinematicBody2D

onready var Viking = preload("./Viking.gd").new()
const game_over_scene = preload("res://scenes/GameOver.tscn")

const TARGET_FPS = 60
const ACCELERATION = 8
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140
var SPEED = 30
var HP = 50
var velocity = Vector2.ZERO
var state_machine
var body_entered = false

func _process(delta):
	
	state_machine = $AnimationTree.get("parameters/playback")
	var current = state_machine.get_current_node()
	if body_entered == true && Viking.HP > 0:
		state_machine.travel("attack")
		print(Viking.HP)
		

func _physics_process(delta):
	
	#velocity.x = SPEED
	velocity.y += GRAVITY
	
	
	velocity = move_and_slide(velocity, Vector2.UP)

func handle_hit():
	HP -= 10
	if (HP > 0):
		$AttackSprite.visible = false
		$HurtSprite.visible = true
		state_machine.travel("hurt")
		print("Skeleton was hit!")
		yield(get_tree().create_timer(0.5), "timeout")
		$HurtSprite.visible = false
		$AttackSprite.visible = true
	
	if HP <= 0:
		remove_child($AttackSprite)
		remove_child($IdleSprite)
		remove_child($HurtSprite)
		$DeathSprite.visible = true
		state_machine.travel("death")
		
func _on_AxeHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()

func _on_AttackTrigger_body_entered(body):
	body_entered = true
	print("body entered")

func _on_AttackTrigger_body_exited(body):
	body_entered = false

