# Egyszerű visszalépés a főmenübe, várakozás és saját hangjelzés nélkül.
extends TextureButton

# A gomb megnyomásakor megnyitja ezt a jelenetet: menü.
func _pressed():
	get_tree().change_scene_to_file("res://scenes/menü.tscn")
