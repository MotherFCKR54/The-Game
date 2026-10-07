# A dugvillán 1,5 másodperces nyomva tartás után vált a bedugott és kihúzott állapot között.
extends Area2D
signal activated
var holding := false
var elapsed := 0.0

func _ready() -> void:
	mouse_exited.connect(_cancel)

# Csak a dugvillán megkezdett bal kattintás indítja a váltást.
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_cancel()
		holding = event.pressed

# Az egér felengedése a dugvillán kívül is megszakítja a számlálást.
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
		# Egy nyomva tartás csak egyszer vált; új váltáshoz új kattintás kell.
		activated.emit()

# A pause menü megnyitása sem hagy félbehagyott felvételt a háttérben.
func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		_cancel()

func _cancel() -> void:
	holding = false
	elapsed = 0.0
