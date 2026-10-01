# A cetli közös, nagyított olvasónézete a fiókból és az inventoryból is.
extends CanvasLayer

var item_id: String = "cetli"
var _was_paused := false
var _closing := false
var _sheet: TextureRect
var _store_button: Button
var _back_button: Button

# A játékhoz illő fehér feliratot, fekete alapot és piros ecsetes kiemelést készít.
static func style_button(button: Button) -> void:
	var normal := StyleBoxTexture.new()
	normal.texture = preload("res://pictures/Pause.png")
	var brush := AtlasTexture.new()
	brush.atlas = preload("res://pictures/pause4.4.png")
	# Csak a felirat nélküli bal oldali ecsetvonást használjuk háttérként.
	brush.region = Rect2(0, 0, 300, 191)
	var hover := StyleBoxTexture.new()
	hover.texture = brush
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	button.add_theme_stylebox_override("focus", hover)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_font_size_override("font_size", 28)
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Segoe Print", "Comic Sans MS"])
	button.add_theme_font_override("font", font)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

# Külön, felső rétegen jelenik meg, miközben a háttérben a játék szünetel.
func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("note_reader")
	_was_paused = get_tree().paused
	get_tree().paused = true
	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.88)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	_sheet = TextureRect.new()
	_sheet.name = "Cetli1"
	_sheet.texture = load("res://pictures/cetli2.png" if item_id == "cetli2" else "res://pictures/cetli1.png")
	_sheet.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_sheet.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_sheet.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_sheet)
	_store_button = Button.new()
	_store_button.name = "Elrakas"
	_store_button.text = "Elrakás"
	style_button(_store_button)
	_store_button.pressed.connect(_store_note)
	add_child(_store_button)
	_back_button = Button.new()
	_back_button.name = "Vissza"
	_back_button.text = "Vissza"
	style_button(_back_button)
	_back_button.pressed.connect(close)
	add_child(_back_button)
	get_viewport().size_changed.connect(_layout)
	_layout()
	# Rövid, középpont körüli közelítés, a szöveg végül teljes méretben marad.
	_sheet.scale = Vector2.ONE * 0.82
	_sheet.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_sheet, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(_sheet, "modulate:a", 1.0, 0.22)

# A képernyőhöz igazítja a cetlit: a szöveg torzítás és levágás nélkül olvasható.
func _layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var available := Vector2(viewport_size.x - 40, maxf(100, viewport_size.y - 108))
	var image_size := _sheet.texture.get_size()
	var fit := minf(available.x / image_size.x, available.y / image_size.y)
	_sheet.size = image_size * fit
	_sheet.position = Vector2((viewport_size.x - _sheet.size.x) / 2, 12)
	_sheet.pivot_offset = _sheet.size / 2
	var width := minf(230, (viewport_size.x - 60) / 2)
	_store_button.size = Vector2(width, 64)
	_back_button.size = Vector2(width, 64)
	_store_button.position = Vector2(viewport_size.x / 2 + 10, viewport_size.y - 80)
	_back_button.position = Vector2(viewport_size.x / 2 - width - 10, viewport_size.y - 80)

# Csak egyszer adja hozzá a cetlit; inventoryból újraolvasva nem keletkezik másolat.
func _store_note() -> void:
	if _closing:
		return
	if SaveManager.get_item_count(item_id) == 0:
		SaveManager.add_item(item_id)
	close()

# Esc bezárja az olvasót; a pause menü nem kapja meg ugyanazt a gombnyomást.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		close()

# Visszaállítja a korábbi szünetállapotot: a fiók nyitva maradhat mögötte.
func close() -> void:
	if _closing:
		return
	_closing = true
	get_tree().paused = _was_paused
	queue_free()
