extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_pressed() -> void:
	$"../AudioStreamPlayer".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")
	




func _on_mouse_entered() -> void:
	$"../AudioStreamPlayer2".play()
