extends Control

var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		self.is_paused = !is_paused
		
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
func _on_beallitas_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")
	
func _on_folytatas_pressed() -> void:
	$buttonpress.play()
	get_tree().paused = !is_paused
	visible = !is_paused
	
func _on_kilepes_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")


func _on_beallitas_mouse_entered() -> void:
	$"Egérrávitel".play()

func _on_folytatas_mouse_entered() -> void:
	$"Egérrávitel".play()

func _on_iranyitas_mouse_entered() -> void:
	$"Egérrávitel".play()

func _on_kilepes_mouse_entered() -> void:
	$"Egérrávitel".play()
