extends Node2D


func _on_texture_button_pressed() -> void:
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	




func _on_texture_button_mouse_entered() -> void:
	$"Egérrávitel".play()
