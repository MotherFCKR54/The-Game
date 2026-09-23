# A stáblista visszalépő gombja: hangjelzés után megnyitja a főmenüt.
extends TextureButton


# A gomb megnyomásakor megnyitja ezt a jelenetet: menü. Előtte hangot játszik le, és egy másodpercet vár.
func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
