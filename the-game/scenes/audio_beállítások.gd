extends Control

func _ready() -> void:
	$VBoxContainer/FőhangerőSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/ZeneSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_zene_slider_mouse_exited() -> void:
	release_focus()


func _on_sfx_slider_mouse_exited() -> void:
	release_focus()


func _on_főhangerő_slider_mouse_exited() -> void:
	release_focus()
