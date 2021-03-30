extends "res://scripts/StateMachine.gd"

func _state_logic(delta):
	add_state("idle")
	add_state("walk")
	add_state("attack")
	add_state("hurt")
	add_state("death")
	call_deferred("set_state", states.idle)

func _get_transition(delta):
	return null
	
func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
