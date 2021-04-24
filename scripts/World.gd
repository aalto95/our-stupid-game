extends Node2D

func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://scenes/SecondLevel.tscn")
	queue_free()

func _process(delta):
	if global.player.HP <= 0:
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		queue_free()
