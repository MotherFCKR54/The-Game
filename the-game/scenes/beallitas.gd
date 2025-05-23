extends TextureButton



func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()


func _on_nyelv_pressed() -> void:
	$"../AudioStreamPlayer".play()


func _on_stáblista_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/credits.tscn")



func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()


func _on_nyelv_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()


func _on_stáblista_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()

func _on_hangok_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Hangok.tscn")

func _on_hangok_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	
func _on_v_issza_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")

func _on_v_issza_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	$"../VIssza".scale *= 1.1
	$"../VIssza".position.x -= 10
	$"../VIssza".position.y -= 10

func _on_mouse_exited() -> void:
	$"../VIssza".scale /= 1.1
	$"../VIssza".position.x += 10
	$"../VIssza".position.y += 10
