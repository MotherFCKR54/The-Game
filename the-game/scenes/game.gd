# A játékpálya vezérlője: inventory-kijelzés, automatikus mentés és fióknyitás.
extends Node2D

# Előre betölti a fiók jelenetét, hogy megnyitáskor példányosítható legyen.
var fiok_scene = preload("res://scenes/fiók.tscn")

# A tárgylista feliratainak és kattintható tárgygombjainak tárolója.
var inventory_list: VBoxContainer
# A teljes inventory-panelt elrejtjük, amikor nincs benne tárgy.
var inventory_panel: PanelContainer
const NoteReader = preload("res://scenes/note_reader.gd")

# Felépíti a tárgylista felületét, beköti a frissítést és a pozíciómentést, majd elindítja az időzítőt.
func _ready() -> void:
	# Külön képernyőréteg a tárgylistának, hogy a pálya világától elkülönítve jelenjen meg.
	var hud := CanvasLayer.new()
	add_child(hud)
	var panel := PanelContainer.new()
	inventory_panel = panel
	panel.position = Vector2(16, 16)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(panel)
	# Tizenkét pixeles belső térközt ad a szöveg köré.
	var margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 12)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(margin)
	inventory_list = VBoxContainer.new()
	margin.add_child(inventory_list)
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

# Újraépíti a tárgylistát; a cetli kattintható, a többi tárgy darabszámmal jelenik meg.
func _refresh_inventory() -> void:
	for child in inventory_list.get_children():
		inventory_list.remove_child(child)
		child.queue_free()
	inventory_panel.visible = not SaveManager.inventory.is_empty()
	if SaveManager.inventory.is_empty():
		return
	var title := Label.new()
	title.text = "Inventory"
	inventory_list.add_child(title)
	for item: String in SaveManager.inventory:
		if item == "cetli":
			var button := Button.new()
			button.name = "Cetli"
			# A tárgy neve csak rámutatáskor, súgóbuborékban jelenik meg.
			button.tooltip_text = "Cetli"
			button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			button.icon = preload("res://pictures/cetli1-arnyekkal.png")
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 54)
			button.custom_minimum_size = Vector2(80, 64)
			# Az inventory ikonja minden állapotban háttér és keret nélkül jelenik meg.
			for state in ["normal", "hover", "pressed", "disabled", "focus"]:
				button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			button.pressed.connect(_open_inventory_note)
			inventory_list.add_child(button)
		else:
			var label := Label.new()
			label.text = "%s × %d" % [item, SaveManager.get_item_count(item)]
			inventory_list.add_child(label)

# Az inventoryból ugyanazt a nagyított cetlit nyitja meg, másolat létrehozása nélkül.
func _open_inventory_note() -> void:
	if SaveManager.get_item_count("cetli") == 0:
		return
	if get_tree().get_nodes_in_group("note_reader").is_empty():
		add_child(NoteReader.new())

# Példányosítja az előre betöltött fiókjelenetet és hozzáadja a pályához.
func fioknyitas():
	if not get_tree().get_nodes_in_group("drawer_view").is_empty():
		return
	var fiok = fiok_scene.instantiate()
	add_child(fiok)
