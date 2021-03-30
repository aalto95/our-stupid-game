extends KinematicBody2D

const GameOverScene = preload("res://scenes/GameOver.tscn")

const GRAVITY = 4
var SPEED = 30
var HP = 50
var velocity = Vector2.ZERO
var state_machine
var body_entered = false
var current
var is_dead = false

func _ready():
	global.skeleton = self

func dead():
	is_dead = true
	state_machine.travel("death")
	$DeathSound.play()
	
func handle_hit():
	HP -= 10
	if HP > 0 or HP == 0:
		if (global.player.current == "attack1"):
			$HurtWithSwordSound1.play()
			$HurtSound.play()
		if (global.player.current == "attack2"):
			$HurtWithSwordSound2.play()
			$HurtSound.play()
		state_machine.travel("hurt")
		print("Skeleton was hit!")
	if HP == 0:
		dead()
	
func _process(delta):
	
	print(is_dead)
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
		$AnimatedSprite.play("attack")
		$AttackSprite.visible = true
		$IdleSprite.visible = false
		$WalkSprite.visible = false
		$HurtSprite.visible = false
		if $AxeSwingSound.playing == false:
			$AxeSwingSound.play()
		
	if current == "death":
		$DeathSprite.visible = true
		$AttackSprite.visible = false
		$IdleSprite.visible = false
		$HurtSprite.visible = false
		$WalkSprite.visible = false
		
	if current == "idle":
		$IdleSprite.visible = true
		$WalkSprite.visible = false
		$AttackSprite.visible = false
		$HurtSprite.visible = false
	
	if current == "walk":
		$IdleSprite.visible = false
		$WalkSprite.visible = true
		$AttackSprite.visible = false
		if $FootstepSound.playing == false:
			$FootstepSound.play()
		
	while body_entered and !global.player.is_dead and !is_dead:
		state_machine.travel("attack")
		yield(get_tree().create_timer(1.8), "timeout")
		
	if global.player.global_position.x < global_position.x + 10 and !global.player.is_dead and !is_dead and $RayCast2D.is_colliding():
		state_machine.travel("walk")
		velocity.x = -SPEED
		$AttackSprite.scale.x = -1
		$WalkSprite.scale.x = -1
		$HurtSprite.scale.x = -1
		$DeathSprite.scale.x = -1
		$AttackSprite.position.x = $CollisionShape2D.position.x - 10
		$WalkSprite.position.x = $CollisionShape2D.position.x - 3
		
	elif global.player.global_position.x > global_position.x - 10 and global.player.HP > 0 and HP > 0 and $RayCast2D.is_colliding() :
		state_machine.travel("walk")
		velocity.x = SPEED
		$AttackSprite.scale.x = 1
		$WalkSprite.scale.x = 1
		$HurtSprite.scale.x = 1
		$DeathSprite.scale.x = 1
		$AttackSprite.position.x = $CollisionShape2D.position.x + 10
		$WalkSprite.position.x = $CollisionShape2D.position.x + 3
		
	elif velocity.x == 0 and !is_dead:
		state_machine.travel("idle")
		
func _physics_process(delta):
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)



		
func _on_AxeHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
	$AxeHitSound.play()

func _on_AttackTrigger_body_entered(body):
	body_entered = true
	print("body entered")

func _on_AttackTrigger_body_exited(body):
	body_entered = false
	print("body quit")

