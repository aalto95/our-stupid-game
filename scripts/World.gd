extends Node2D

func _process(delta):
	if $RayCast2D.is_colliding():
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		print("hellooo")
