# A Muzikri doboz 1,5 másodperces folyamatos nyomásra egyszer adja oda a második cetlit.
extends Area2D
var holding := false
var elapsed := 0.0

func _ready() -> void:
	mouse_exited.connect(_cancel)

# Csak a dobozon megkezdett bal kattintás indítja a felvételt.
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_cancel()
		holding = event.pressed and SaveManager.get_item_count("cetli2") == 0

# Az egér felengedése a dobozon kívül is megszakítja a számlálást.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		_cancel()

func _process(delta: float) -> void:
	if not holding:
		return
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_cancel()
		return
	elapsed += delta
	if elapsed >= 1.5:
		_cancel()
		if SaveManager.get_item_count("cetli2") == 0:
			SaveManager.add_item("cetli2")

# A pause menü megnyitása sem hagy félbehagyott felvételt a háttérben.
func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		_cancel()

func _cancel() -> void:
	holding = false
	elapsed = 0.0
