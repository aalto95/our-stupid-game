extends KinematicBody2D

var velocity = Vector2.ZERO
var state_machine
var current
var HP = 50

func handle_hit():
	HP -= 10
	if HP > 0:
		state_machine.travel("hurt")
		$HurtSound.play()
	if HP == 0:
		state_machine.travel("death")
	
func _process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	current = state_machine.get_current_node()
	if HP > 0 and current != "hurt":
		if $WingsFlapSound.playing == false:
			$WingsFlapSound.play()
	else:
		$WingsFlapSound.stop()
		
	if current == "idle":
		$HurtSprite.visible = false
		$IdleSprite.visible = true
		
	if current == "hurt":
		$IdleSprite.visible = false
		$HurtSprite.visible = true
	
	if current == "death":
		$IdleSprite.visible = false
		$HurtSprite.visible = false
		$DeathSprite.visible = true
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
