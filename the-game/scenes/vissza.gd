extends TextureButton

func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")

func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	scale *= 1.1
	position.x -= 10
	position.y -= 10

func _on_mouse_exited() -> void:
	scale /= 1.1
	position.x += 10
	position.y += 10
