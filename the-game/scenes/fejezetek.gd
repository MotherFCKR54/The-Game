# A fejezetválasztó játékindító gombjának kattintását és egérhangját kezeli.
extends Node2D


# A gomb megnyomásakor megnyitja ezt a jelenetet: game. Előtte hangot játszik le, és egy másodpercet vár.
func _on_texture_button_pressed() -> void:
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	




# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_texture_button_mouse_entered() -> void:
	$"Egérrávitel".play()
