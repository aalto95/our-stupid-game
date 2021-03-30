extends "res://scripts/StateMachine.gd"

func _state_logic(delta):
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack1")
	add_state("attack2")
	add_state("hurt")
	add_state("death")
	call_deferred("set_state", states.idle)

func _input(event):
	#if [states.idle, states.run].has(state):
		if Input.is_action_just_pressed("ui_up") and parent.is_on_floor():
			parent.is_jumping = true
			parent.velocity.y = -parent.JUMP_FORCE

func _get_transition(delta):
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement(	)
	
func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass


