extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
var MAX_SPEED = 64
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140
var player_position = 0
var velocity = Vector2.ZERO
var HP = 30
var x_input = 0
var state_machine
var current 
var is_dead = false
var is_grounded
var is_jumping

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	state_machine.travel("die")
	set_physics_process(false) #Disable physics
	get_tree().get_root().set_disable_input(true) #Disable input
	$CollisionShape2D.disabled = true
	
func _ready():
	global.player = self

func _process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	current = state_machine.get_current_node()
	state_machine.travel("idle")
	if x_input != 0:
		state_machine.travel("run")
	else:
		state_machine.travel("idle")
		
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
	
	if Input.is_action_just_pressed("ui_right") && HP > 0:
		$Sprite.scale.x = 1
	
	if HP <= 0:
		dead()

func _physics_process(delta):
	is_grounded = is_on_floor()
	_handle_move_input()
	_apply_gravity(delta)
	_apply_movement(delta)

func _apply_gravity(delta):
	velocity.y += GRAVITY * delta * TARGET_FPS
	
func _apply_movement(delta):
	if is_jumping && velocity.y >= 0:
		is_jumping = false
		
	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	if is_grounded && x_input == 0:
		velocity.x = lerp(velocity.x, 0, FRICTION * delta) #disable slipping
			
func _handle_move_input():
	x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	
		
	if x_input != 0:
		velocity.x += x_input * ACCELERATION * TARGET_FPS #enable movement on x axis
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED) #disable infinite speed
		
func handle_hit():
	HP -= 10
	print("Player was hit!")
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

	 
func _on_SwordHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
