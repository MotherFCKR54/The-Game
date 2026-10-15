# Kattintható pinpad: legfeljebb nyolc számjegy, törlés, ellenőrzés és 1,5 másodperces visszajelzés.
extends CanvasLayer
signal code_accepted
const MAX_DIGITS := 8
var correct_code: String = ""
var entered_code := ""
var _was_paused := false
var _closing := false
var _busy := false
var _content: Control
var _display: Label
var _indicator: TextureRect
var _feedback_timer: Timer
var _buttons: Array[Button] = []

# A grafika saját számbillentyűi fölé átlátszó, kattintható gombokat helyez.
func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("codegate_view")
	_was_paused = get_tree().paused
	get_tree().paused = true
	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.88)
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_content = Control.new()
	_content.size = Vector2(330, 490)
	add_child(_content)
	var picture := TextureRect.new()
	picture.texture = preload("res://newpictures/codegate.png")
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.size = _content.size
	_content.add_child(picture)
	_display = Label.new()
	_display.position = Vector2(84, 135)
	_display.size = Vector2(160, 36)
	_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_display.clip_text = true
	_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_display.add_theme_color_override("font_color", Color(0.035, 0.10, 0.025))
	_display.add_theme_font_size_override("font_size", 25)
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Consolas", "Courier New"])
	_display.add_theme_font_override("font", font)
	_content.add_child(_display)
	_indicator = TextureRect.new()
	# További 15%-kal nagyított jelzőfény, változatlan középponttal.
	_indicator.position = Vector2(138.125, 26.225)
	_indicator.size = Vector2(51.75, 65.55)
	_indicator.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_indicator.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_indicator.hide()
	_content.add_child(_indicator)
	for row in range(4):
		for column in range(3):
			var value: String = str(row * 3 + column + 1) if row < 3 else ["clear", "0", "submit"][column]
			var button := Button.new()
			button.name = "Key_" + value
			button.position = Vector2([78, 138, 200][column], 198 + row * 50)
			button.size = Vector2(52, 45)
			button.focus_mode = Control.FOCUS_NONE
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			button.tooltip_text = "Törlés" if value == "clear" else ("Ellenőrzés" if value == "submit" else value)
			for state in ["normal", "disabled", "focus"]:
				button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
			var hover := StyleBoxFlat.new()
			hover.bg_color = Color(1, 1, 1, 0.15)
			hover.set_corner_radius_all(5)
			button.add_theme_stylebox_override("hover", hover)
			button.add_theme_stylebox_override("pressed", hover)
			button.pressed.connect(_press_key.bind(value))
			_content.add_child(button)
			_buttons.append(button)
	var back := TextureButton.new()
	back.texture_normal = preload("res://pictures/nyil1crop.png")
	back.texture_hover = preload("res://pictures/nyil2crop.png")
	back.texture_pressed = back.texture_hover
	back.ignore_texture_size = true
	back.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	back.position = Vector2(16, 16)
	back.size = Vector2(130, 79)
	back.tooltip_text = "Vissza"
	back.pressed.connect(close)
	add_child(back)
	_feedback_timer = Timer.new()
	_feedback_timer.one_shot = true
	_feedback_timer.wait_time = 1.5
	_feedback_timer.timeout.connect(_finish_feedback)
	add_child(_feedback_timer)
	get_viewport().size_changed.connect(_layout)
	_layout()

# A panel és minden kattintható mező együtt méreteződik, így a gombok a képen maradnak.
func _layout() -> void:
	var screen := get_viewport().get_visible_rect().size
	var fit := minf((screen.x - 32) / 330.0, (screen.y - 32) / 490.0)
	_content.scale = Vector2.ONE * fit
	_content.position = (screen - _content.size * fit) / 2

# A kezdő nullákat is megőrzi; X az egészet, Backspace az utolsó számjegyet törli.
func _press_key(value: String) -> void:
	if _busy or _closing:
		return
	match value:
		"clear": entered_code = ""
		"backspace": entered_code = entered_code.left(maxi(0, entered_code.length() - 1))
		"submit":
			_submit()
			return
		_:
			if value.length() == 1 and value in "0123456789" and entered_code.length() < MAX_DIGITS:
				entered_code += value
	_display.text = entered_code

# Üresen hagyott helyes kód mellett nincs elfogadott kombináció; nem használunk ideiglenes titkos kódot.
func _submit() -> void:
	var valid := not correct_code.is_empty() and entered_code == correct_code
	_busy = true
	for button in _buttons:
		button.disabled = true
	_indicator.texture = preload("res://newpictures/codegateright2.png") if valid else preload("res://newpictures/codegatewrong2.png")
	_indicator.show()
	_feedback_timer.start()
	if valid:
		code_accepted.emit()

# A jelzés után új próbálkozás indítható; a piros vagy zöld fény 1,5 másodpercig látszik.
func _finish_feedback() -> void:
	_indicator.hide()
	entered_code = ""
	_display.text = ""
	_busy = false
	for button in _buttons:
		button.disabled = false

# A billentyűzet és a numerikus billentyűzet is használható. Esc visszalép.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		close()
	elif event is InputEventKey and event.pressed and not event.echo:
		var key: int = event.keycode
		if key >= KEY_0 and key <= KEY_9:
			_press_key(str(key - KEY_0))
		elif key >= KEY_KP_0 and key <= KEY_KP_9:
			_press_key(str(key - KEY_KP_0))
		elif key == KEY_BACKSPACE:
			_press_key("backspace")
		elif key == KEY_DELETE:
			_press_key("clear")
		elif key in [KEY_ENTER, KEY_KP_ENTER]:
			_press_key("submit")
		get_viewport().set_input_as_handled()

func close() -> void:
	if _closing:
		return
	_closing = true
	get_tree().paused = _was_paused
	queue_free()
