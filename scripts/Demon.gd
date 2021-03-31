extends KinematicBody2D

var velocity = Vector2.ZERO
var state_machine
var current
var HP = 50
var body_entered = false

func handle_hit():
	HP -= 10
	if HP > 0:
		state_machine.travel("hurt")
		$HurtSound.play()
	if HP == 0:
		state_machine.travel("death")
		
func going_up():
	velocity.y -= 1
	
func going_down():
	velocity.y += 1
	
func _process(delta):
	print(current)
	state_machine = $AnimationTree.get("parameters/playback")
	current = state_machine.get_current_node()
	if body_entered == true && HP > 0:
		state_machine.travel("attack")
		#yield(get_tree().create_timer(1.0), "timeout")
		
	if HP > 0 and current != "hurt":
		if $WingsFlapSound.playing == false:
			$WingsFlapSound.play()
	else:
		$WingsFlapSound.stop()
		
	if current == "idle":
		$HurtSprite.visible = false
		$IdleSprite.visible = true
		$AttackSprite.visible = false

	if current == "hurt":
		$IdleSprite.visible = false
		$HurtSprite.visible = true
	
	if current == "death":
		$IdleSprite.visible = false
		$HurtSprite.visible = false
		$AttackSprite.visible = false
		$DeathSprite.visible = true
		
	if current == "attack":
		$IdleSprite.visible = false
		$HurtSprite.visible = false
		$AttackSprite.visible = true
		$WingsFlapSound.stop()
		if !$DemonBreathe.playing:
			$DemonBreathe.play()
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_body_entered(body):
	body_entered = true
	print("body entered")
	

func _on_Area2D_body_exited(body):
	body_entered = false
	print("body exited")

func _on_FireHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
