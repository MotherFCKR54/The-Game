extends TextureButton
func _on_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
func _on_beállítások_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")
func _on_beállítások_mouse_entered() -> void:
	$"../egerravitel".play(1)
func _on_credits_mouse_entered() -> void:
	$"../egerravitel".play(1)
func _on_mouse_entered() -> void:
	$"../egerravitel".play()
func _on_credits_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
