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

func handle_hit():
	HP -= 10
	state_machine.travel("block")
	print("Player was hit!")
	if HP <= 0:
		state_machine.travel("death") 
	
func _unhandled_input(event):
	if event is InputEventKey:
		if !event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 64
		elif event.pressed and event.scancode == KEY_SHIFT:
			MAX_SPEED = 96
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		if event.pressed and event.scancode == KEY_E:
			state_machine.travel("attack1")

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
func _process(delta):
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
	


func _on_SwordHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
