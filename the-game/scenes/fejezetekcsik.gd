# A fejezetválasztó képes gombja: kattintáskor közvetlenül betölti a játékpályát.
extends TextureButton


# Jelenleg üres indulási függvény; a pass nem végez műveletet.
func _ready() -> void:
	pass


# Képkockánként meghívódik, de jelenleg üres, ezért nem végez műveletet.
func _process(delta: float) -> void:
	pass


# A gomb megnyomásakor megnyitja ezt a jelenetet: game.
func _on_pressed() -> void:
	$"../buttonpress".play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_mouse_entered() -> void:
	$"../Egérrávitel".play()
