extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
var MAX_SPEED = 64
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140
var player_position = 0
var state_machine
var motion = Vector2.ZERO

var x_input = 0

func handle_hit():
	print("Player was hit!")
	
func _unhandled_input(event):
	if event is InputEventKey:
		if !event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 64
		elif event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 96
			
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	var current = state_machine.get_current_node()
	state_machine.travel("idle")
	if x_input != 0:
		state_machine.travel("run")
		$Sprite.flip_h = x_input < 0
	if !is_on_floor():
		state_machine.travel("jump")
		
func _physics_process(delta):
	
	x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	else:     
		pass
		#state_machine.travel("idle")
	
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		pass
		#animationPlayer.play("jump")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion, Vector2.UP)
