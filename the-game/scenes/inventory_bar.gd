# Üresen rejtett, több tárgynál jobbra kinyíló inventory. A tárgynevek csak súgóbuborékban látszanak.
extends Control
const Reader = preload("res://scenes/note_reader.gd")
var _items: Array = []
var _tween: Tween
var _expanded := false
var _row: HBoxContainer
var _title: Label
var _pickup_layer: CanvasLayer
var _pickup_tween: Tween
var _pulse_tween: Tween

func _ready() -> void:
	position = Vector2(16, 16)
	clip_contents = true
	var background := Panel.new()
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_title = Label.new()
	_title.text = "Inventory"
	_title.position = Vector2(12, 8)
	_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_title)
	_row = HBoxContainer.new()
	_row.position = Vector2(12, 36)
	_row.add_theme_constant_override("separation", 8)
	add_child(_row)
	SaveManager.inventory_changed.connect(refresh)
	SaveManager.item_added.connect(_show_pickup)
	refresh()

# Felvételkor rövid jelzés jelenik meg a fiók felett is; nem akadályozza a kattintást.
func _show_pickup(item: String, amount: int) -> void:
	if _pickup_tween:
		_pickup_tween.kill()
	if is_instance_valid(_pickup_layer):
		_pickup_layer.queue_free()
	_pickup_layer = CanvasLayer.new()
	_pickup_layer.layer = 60
	_pickup_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_pickup_layer)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.06, 0.05, 0.95)
	style.border_color = Color(0.65, 0.22, 0.15)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	panel.add_theme_stylebox_override("panel", style)
	_pickup_layer.add_child(panel)
	var label := Label.new()
	var item_name := "Cetli" if item == "cetli" else ("Cetli 2" if item == "cetli2" else item)
	label.text = "%s bekerült az inventoryba" % item_name
	if amount > 1:
		label.text += " (+%d)" % amount
	label.add_theme_font_size_override("font_size", 22)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(label)
	panel.reset_size()
	panel.position = Vector2(maxf(8, (get_viewport().get_visible_rect().size.x - panel.size.x) / 2), 12)
	panel.modulate.a = 0
	_pickup_tween = _pickup_layer.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_pickup_tween.tween_property(panel, "modulate:a", 1.0, 0.18)
	_pickup_tween.parallel().tween_property(panel, "position:y", 28.0, 0.18)
	_pickup_tween.tween_interval(2.3)
	_pickup_tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	_pickup_tween.tween_callback(_pickup_layer.queue_free)
	# A felirat rövid aranyszínű villanása ráirányítja a figyelmet az inventoryra.
	if _pulse_tween:
		_pulse_tween.kill()
	_title.modulate = Color(1.0, 0.65, 0.25)
	_pulse_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_pulse_tween.tween_property(_title, "modulate", Color.WHITE, 1.0)

# A szélesség animálása felfedi a vízszintesen sorba rendezett tárgyakat.
func refresh() -> void:
	if _tween:
		_tween.kill()
	for child in _row.get_children():
		_row.remove_child(child)
		child.queue_free()
	_items = SaveManager.inventory.keys()
	visible = not _items.is_empty()
	_expanded = false
	size = Vector2(132, 108)
	_title.text = "Inventory ›" if _items.size() > 1 else "Inventory"
	for item: String in _items:
		var button := Button.new()
		button.name = item
		button.custom_minimum_size = Vector2(108, 64)
		button.tooltip_text = "Cetli" if item == "cetli" else ("Cetli 2" if item == "cetli2" else item)
		for state in ["normal", "hover", "pressed", "disabled", "focus"]:
			button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.add_theme_constant_override("icon_max_width", 80)
		if item in ["cetli", "cetli2"]:
			button.icon = load("res://pictures/cetli1-arnyekkal.png" if item == "cetli" else "res://pictures/cetli2.png")
			button.pressed.connect(_open_note.bind(item))
		else:
			button.text = "× %d" % SaveManager.get_item_count(item)
		_row.add_child(button)

# A teljes nyitott felületen vizsgáljuk az egeret, így a tárgyak között nem csukódik össze.
func _process(_delta: float) -> void:
	if not visible or _items.size() < 2:
		return
	var hovered := get_global_rect().has_point(get_global_mouse_position())
	if hovered != _expanded:
		set_expanded(hovered)

func set_expanded(value: bool) -> void:
	_expanded = value
	if _tween:
		_tween.kill()
	var width: float = 24.0 + _items.size() * 108.0 + max(0, _items.size() - 1) * 8.0 if value else 132.0
	_tween = create_tween()
	_tween.tween_property(self, "size:x", width, 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# Mindkét cetli ugyanabban a nagyított olvasóban nyílik meg.
func _open_note(item: String) -> void:
	if not get_tree().get_nodes_in_group("note_reader").is_empty():
		return
	var reader := Reader.new()
	reader.item_id = item
	get_tree().current_scene.add_child(reader)
