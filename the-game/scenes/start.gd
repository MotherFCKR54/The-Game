# A főmenü gombjait kezeli: új játék, folytatás, beállítások és kilépés.
extends TextureButton
# Elindítja a háttérzenét, és csak érvényes mentés esetén jeleníti meg a Folytatás gombot.
func _ready() -> void:
	$"../háttérzene".play()
	$"../Folytatás".visible = SaveManager.has_save()
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: fejezetek. Előtte hangot játszik le, és egy másodpercet vár. Előbb törli a memóriában lévő játékállapotot az új játékhoz.
func _on_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://scenes/fejezetek.tscn")
# A gomb megnyomásakor megnyitja ezt a jelenetet: beállítások. Előtte hangot játszik le, és egy másodpercet vár.
func _on_beállítások_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")
# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_beállítások_mouse_entered() -> void:
	$"../egerravitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_mouse_entered() -> void:
	$"../egerravitel".play()


# A gomb megnyomásakor hangjelzés és egy másodperc után visszatölti a mentett játékot.
func _on_folytatás_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	SaveManager.continue_game()
	

# A gomb megnyomásakor hangjelzés és egy másodperc után bezárja a játékot.
func _on_kilépés_pressed() -> void:
	$"../kattintas".play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_folytatás_mouse_entered() -> void:
	$"../egerravitel".play()



# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_kilépés_mouse_entered() -> void:
	$"../egerravitel".play()
