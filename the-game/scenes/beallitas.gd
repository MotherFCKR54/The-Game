# A beállítások menü gombjai: hangjelzések, menüváltás és a Vissza gomb kiemelése.
extends TextureButton



# A gomb megnyomásakor kattintási hangot játszik le; itt más művelet még nincs bekötve.
func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()


# A gomb megnyomásakor kattintási hangot játszik le; itt más művelet még nincs bekötve.
func _on_nyelv_pressed() -> void:
	$"../AudioStreamPlayer".play()


# A gomb megnyomásakor megnyitja ezt a jelenetet: credits. Előtte hangot játszik le, és egy másodpercet vár.
func _on_stáblista_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/credits.tscn")



# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_nyelv_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_stáblista_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()

# A gomb megnyomásakor megnyitja ezt a jelenetet: Hangok. Előtte hangot játszik le, és egy másodpercet vár.
func _on_hangok_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Hangok.tscn")

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_hangok_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: menü. Előtte hangot játszik le, és egy másodpercet vár.
func _on_v_issza_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját. Emellett felnagyítja és eltolja a Vissza gombot.
func _on_v_issza_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
	$"../VIssza".scale *= 1.1
	$"../VIssza".position.x -= 10
	$"../VIssza".position.y -= 10

# Visszaállítja a gomb méretét és helyét az egérrel történő kiemelés után.
func _on_mouse_exited() -> void:
	$"../VIssza".scale /= 1.1
	$"../VIssza".position.x += 10
	$"../VIssza".position.y += 10
