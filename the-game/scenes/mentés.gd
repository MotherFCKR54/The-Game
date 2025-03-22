extends Button

func _on_pressed() -> void:
	$"../../AudioStreamPlayer".play()
	
func _on_mouse_entered() -> void:
	
	$"../../AudioStreamPlayer2".play()
