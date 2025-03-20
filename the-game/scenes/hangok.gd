extends Node2D

func _on_mentés_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($"AudioBeállítások/VBoxContainer/FőhangerőSlider".value))
	AudioServer.set_bus_volume_db(1, linear_to_db($"AudioBeállítások/VBoxContainer/SFXSlider".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"AudioBeállítások/VBoxContainer/ZeneSlider".value))
	
	
