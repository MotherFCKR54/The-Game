# A játékpálya vezérlője: inventory-kijelzés, automatikus mentés és fióknyitás.
extends Node2D

# Előre betölti a fiók jelenetét, hogy megnyitáskor példányosítható legyen.
var fiok_scene = preload("res://scenes/fiók.tscn")

# A kódból létrehozott tárgylista szöveges felülete.
var inventory_label: Label

# Felépíti a tárgylista felületét, beköti a frissítést és a pozíciómentést, majd elindítja az időzítőt.
func _ready() -> void:
	# Külön képernyőréteg a tárgylistának, hogy a pálya világától elkülönítve jelenjen meg.
	var hud := CanvasLayer.new()
	add_child(hud)
	var panel := PanelContainer.new()
	panel.position = Vector2(16, 16)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(panel)
	# Tizenkét pixeles belső térközt ad a szöveg köré.
	var margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 12)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(margin)
	inventory_label = Label.new()
	inventory_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(inventory_label)
	# A tárgyak változására azonnal újrarajzolja a listát.
	SaveManager.inventory_changed.connect(_refresh_inventory)
	_refresh_inventory()
	SaveManager.enter_level(scene_file_path, $CharacterBody2D)
	# A karakter pályáról távozásakor még elmenti az utolsó pozícióját.
	$CharacterBody2D.tree_exiting.connect(_save_position)
	# Két másodpercenként ment; normál szüneteltetéskor ez az időzítő is megáll.
	var autosave := Timer.new()
	autosave.wait_time = 2.0
	autosave.timeout.connect(_save_position)
	add_child(autosave)
	autosave.start()

# A központi mentéskezelővel elmenti a pályát, a tárgyakat és a karakter aktuális helyét.
func _save_position() -> void:
	SaveManager.save_game()

# Ablakbezárási kéréskor vagy az alkalmazás felfüggesztésekor mentést kér.
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		_save_position()

# Újra összeállítja a tárgylista szövegét; üres inventorynál az Üres feliratot mutatja.
func _refresh_inventory() -> void:
	var lines := PackedStringArray(["Inventory"])
	if SaveManager.inventory.is_empty():
		lines.append("Üres")
	for item: String in SaveManager.inventory:
		lines.append("%s × %d" % [item, SaveManager.get_item_count(item)])
	inventory_label.text = "\n".join(lines)

# Példányosítja az előre betöltött fiókjelenetet és hozzáadja a pályához.
func fioknyitas():
	var fiok = fiok_scene.instantiate()
	add_child(fiok)
