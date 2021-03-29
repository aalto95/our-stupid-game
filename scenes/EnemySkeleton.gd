extends KinematicBody2D

const GameOverScene = preload("res://scenes/GameOver.tscn")

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
var current

func _ready():
	global.skeleton = self
	
func handle_hit():
	HP -= 10
	if (global.player.current == "attack1"):
		$HurtWithSwordSound1.play()
	if (global.player.current == "attack2"):
		$HurtWithSwordSound2.play()
	if (HP > 0):
		state_machine.travel("hurt")
		print("Skeleton was hit!")
	if HP <= 0:
		state_machine.travel("death")
	
func _process(delta):
	velocity.x = 0
	state_machine = $AnimationTree.get("parameters/playback")
	current = state_machine.get_current_node()
	
	while current == "hurt":
		$IdleSprite.visible = false
		$WalkSprite.visible = false
		$AttackSprite.visible = false
		$HurtSprite.visible = true
		yield(get_tree().create_timer(0.5), "timeout")
		$HurtSprite.visible = false
		$AttackSprite.visible = true
		$WalkSprite.visible = true
	
	if current == "attack":
		$IdleSprite.visible = false
		$WalkSprite.visible = false
		$HurtSprite.visible = false
		$AttackSprite.visible = true
	
	if current == "death":
		$AttackSprite.visible = false
		$IdleSprite.visible = false
		$HurtSprite.visible = false
		$WalkSprite.visible = false
		$DeathSprite.visible = true
	
	if current == "idle":
		$WalkSprite.visible = false
		$IdleSprite.visible = true
		$AttackSprite.visible = false
	
	if current == "walk":
		$IdleSprite.visible = false
		$WalkSprite.visible = true
		$AttackSprite.visible = false
		
	while body_entered == true and global.player.HP > 0 and HP > 0:
		state_machine.travel("attack")
		yield(get_tree().create_timer(1.8), "timeout")
		
	if global.player.global_position.x < global_position.x + 10 and global.player.HP > 0 and HP > 0 and $RayCast2D.is_colliding() and current != "attack":
		state_machine.travel("walk")
		velocity.x = -SPEED
		$AttackSprite.scale.x = -1
		$WalkSprite.scale.x = -1
		$HurtSprite.scale.x = -1
		$DeathSprite.scale.x = -1
		$AttackSprite.position.x = $CollisionShape2D.position.x - 10
		$WalkSprite.position.x = $CollisionShape2D.position.x - 3
		
	elif global.player.global_position.x > global_position.x - 10 and global.player.HP > 0 and HP > 0 and $RayCast2D.is_colliding() and current != "attack":
		state_machine.travel("walk")
		velocity.x = SPEED
		$AttackSprite.scale.x = 1
		$WalkSprite.scale.x = 1
		$HurtSprite.scale.x = 1
		$DeathSprite.scale.x = 1
		$AttackSprite.position.x = $CollisionShape2D.position.x + 10
		$WalkSprite.position.x = $CollisionShape2D.position.x + 3
		
	elif velocity.x == 0 and HP > 0:
		state_machine.travel("idle")
		
func _physics_process(delta):
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)



		
func _on_AxeHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()

func _on_AttackTrigger_body_entered(body):
	body_entered = true
	print("body entered")

func _on_AttackTrigger_body_exited(body):
	body_entered = false
	print("body quit")

