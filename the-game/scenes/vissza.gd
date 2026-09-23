# Visszalépés a beállításokhoz, hangjelzéssel és egérre történő méretnöveléssel.
extends TextureButton

# A gomb megnyomásakor megnyitja ezt a jelenetet: beállítások. Előtte hangot játszik le, és egy másodpercet vár.
func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját. Emellett felnagyítja és eltolja a Vissza gombot.
func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	scale *= 1.1
	position.x -= 10
	position.y -= 10

# Visszaállítja a gomb méretét és helyét az egérrel történő kiemelés után.
func _on_mouse_exited() -> void:
	scale /= 1.1
	position.x += 10
	position.y += 10
