# A tükör közeli nézete. Vissza gombbal vagy Esc-kel visszatér a játékhoz.
extends CanvasLayer
var _was_paused := false
var _closing := false
var _picture: TextureRect
var _back: TextureButton

func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("mirror_view")
	_was_paused = get_tree().paused
	get_tree().paused = true
	var backdrop := ColorRect.new()
	backdrop.color = Color.BLACK
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_picture = TextureRect.new()
	_picture.texture = preload("res://newpictures/tukorbenezes.png")
	_picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_picture)
	# A fiókból ismert nyíl, külön képpel rámutatáskor és kattintáskor.
	_back = TextureButton.new()
	_back.texture_normal = preload("res://pictures/nyil1crop.png")
	_back.texture_hover = preload("res://pictures/nyil2crop.png")
	_back.texture_pressed = preload("res://pictures/nyil2crop.png")
	_back.ignore_texture_size = true
	_back.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	_back.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_back.tooltip_text = "Vissza"
	_back.pressed.connect(close)
	add_child(_back)
	get_viewport().size_changed.connect(_layout)
	_layout()
	# A valóban megnyitott tükörnézet oldja fel az ajtó kódpaneljét.
	if not SaveManager.mirror_seen:
		SaveManager.mirror_seen = true
		SaveManager.save_game()

# A teljes kép látható marad minden ablakméretnél; a gomb a bal felső sarokban van.
func _layout() -> void:
	_picture.size = get_viewport().get_visible_rect().size
	_back.position = Vector2(16, 16)
	_back.size = Vector2(130, 79)

# Az Esc eseményt elhasználja, így nem nyitja meg egyúttal a pause menüt is.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		close()

# Bezárás után visszaáll a játék előző szünetállapota.
func close() -> void:
	if _closing:
		return
	_closing = true
	get_tree().paused = _was_paused
	queue_free()
