# Az Esc szünetmenüjét, a játék szüneteltetését és a szünetmenü gombjait kezeli.
extends Control

# A setter minden értékadáskor a SceneTree szünetét és a menü láthatóságát is frissíti.
var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		
# Ha az Esc műveletet más kezelő nem fogyasztotta el, átváltja a szünet állapotát.
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		self.is_paused = !is_paused
		
# Kívülről is beállíthatóvá teszi a szünetet, és hozzáigazítja a menü láthatóságát.
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: beállítások. Előtte hangot játszik le, és egy másodpercet vár.
func _on_beallitas_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")
	
# A gomb megnyomásakor hangot játszik le, majd a szünet és a menü láthatóságát az is_paused ellentétére állítja.
func _on_folytatas_pressed() -> void:
	$buttonpress.play()
	get_tree().paused = !is_paused
	visible = !is_paused
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: menü. Előtte hangot játszik le, és egy másodpercet vár.
func _on_kilepes_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_beallitas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_folytatas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_iranyitas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_kilepes_mouse_entered() -> void:
	$"Egérrávitel".play()
