extends TextureButton


func _on_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://game.tscn")
	


func _on_beállítások_pressed() -> void:
	get_tree().change_scene_to_file("res://beállítások.tscn")
	
