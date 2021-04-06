extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 3
const JUMP_FORCE = 140
var SPEED = 30
var HP = 50
var motion = Vector2.ZERO
var state_machine

func _process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	var current = state_machine.get_current_node()
  
	if current == "idle":
		$IdleSprite.visible = true
		$HitSprite.visible = false
		$DeathSprite.visible = false
	if current == "hit":
		$HitSprite.visible = true
		$DeathSprite.visible = false
		$IdleSprite.visible = false
		
	if current == "death":
		
		$HitSprite.visible = false
		$DeathSprite.visible = true
		$IdleSprite.visible = false
		$CollisionShape2D.disabled = true
		set_physics_process(false)
	
	
	
func _physics_process(delta):
	
	#motion.x = SPEED
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP)

func handle_hit():
	
	HP -= 10
	$HitSprite.visible = true
	$RunSprite.visible = false
	$IdleSprite.visible = false
	state_machine.travel("hit")
	
	print("Samurai was hit!")
	if HP == 0:
		$HitSprite.visible = false
		$DeathSprite.visible = true
		$IdleSprite.visible = false
	
		
		 
		state_machine.travel("death")
		
func _on_AxeHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()

