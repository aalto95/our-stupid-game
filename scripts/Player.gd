extends KinematicBody2D

const game_over = preload("res://scenes/GameOver.tscn")
const FIREBALL = preload("res://scenes/FireBall.tscn")
const TARGET_FPS = 60
const ACCELERATION = 8
var MAX_SPEED = 64
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var player_position = 0
var velocity = Vector2.ZERO
var HP = 50
var x_input = 0
var state_machine
var current 

func _ready():
	global.player = self
	

func _process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	current = state_machine.get_current_node()
	state_machine.travel("idle")
	if x_input != 0 and !$RayCast2D.is_colliding():
		state_machine.travel("run")
	else:
		state_machine.travel("idle")
	if $RayCast2D.is_colliding():
		#print("it collides")
		pass
		
	while current == "block":
		velocity.x = 0
		yield(get_tree().create_timer(0.5), "timeout")
		
	if !is_on_floor():
		state_machine.travel("jump")
	
	if current == "attack1":
		if $Whoosh.playing == false:
			$Whoosh.play()
				
	if current == "attack2":
		if $WhooshShort.playing == false:
			$WhooshShort.play()
		
	if Input.is_action_just_pressed("ui_left") && HP > 0:
		$Sprite.scale.x = -1
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		
	if Input.is_action_just_pressed("ui_right") && HP > 0:
		$Sprite.scale.x = 1
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	
	if HP <= 0:
		state_machine.travel("die")
		set_physics_process(false) #Disable physics
		#get_tree().get_root().set_disable_input(true) #Disable input
		yield(get_tree().create_timer(0.5), "timeout")

func _physics_process(delta):
	
	x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		velocity.x += x_input * ACCELERATION * delta * TARGET_FPS
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	velocity.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_FORCE
		
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2:
			velocity.y = -JUMP_FORCE/2
		
		if x_input == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func handle_hit():
	HP -= 10
	print("Player was hit!")
	$HealthBar.value -= 20
	if HP > 0:
		state_machine.travel("block")
		$HurtSound.play()
	if HP == 0:
		$GroanSound.play()
		

	
func _unhandled_input(event):
	if event is InputEventKey:
		if !event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 64
		elif event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 96
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.scancode == KEY_C:
			state_machine.travel("attack1")
		if event.pressed and event.scancode == KEY_F:
			state_machine.travel("attack2")
		if event.pressed and event.scancode == KEY_E:
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position

	 
func _on_SwordHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
