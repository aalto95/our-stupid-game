extends Node2D


func _ready():
		$BackMusic.play()
		

func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://scenes/SecondLevel.tscn")
	queue_free()

func _process(delta):
	if global.player.HP <= 0:
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://scenes/GameOver.tscn")
		queue_free()
	if global.player.global_position.x > 875:
		$StaticBody2D/CollisionShape2D.disabled = false
		$StaticBody2D/Sprite.visible = true
	else:
		$StaticBody2D/CollisionShape2D.disabled = true
		$StaticBody2D/Sprite.visible = false
	if global.demon.HP <= 0:
		$StaticBody2D2/CollisionShape2D.disabled = true
		$StaticBody2D2/Sprite.visible = false
	
