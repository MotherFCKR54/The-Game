# A hangerőcsúszkák kezdőértékeit tölti be az aktuális hangcsatornákból, és kezeli a fókuszt.
extends Control

# A 0., 1. és 2. hangcsatorna decibelértékét lineáris csúszkaértékké alakítja.
func _ready() -> void:
	$VBoxContainer/FőhangerőSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/ZeneSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	
# Az egér távozásakor ezen a Control node-on elengedi a billentyűzetfókuszt.
func _on_főhangerő_slider_mouse_exited() -> void:
	release_focus()

# Az egér távozásakor ezen a Control node-on elengedi a billentyűzetfókuszt.
func _on_zene_slider_mouse_exited() -> void:
	release_focus()

# Az egér távozásakor ezen a Control node-on elengedi a billentyűzetfókuszt.
func _on_sfx_slider_mouse_exited() -> void:
	release_focus()
