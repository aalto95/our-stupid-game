extends Node2D

onready var main_menu = get_node("res://scenes/MainMenu.tscn")


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	queue_free()
