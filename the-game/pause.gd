# Az Esc szünetmenüjét, a játék szüneteltetését és a szünetmenü gombjait kezeli.
extends Control

# A rámutatás az eredeti mérethez képest tíz százalékkal nagyítja a gombokat.
const HOVER_SCALE := 1.1
var _button_scales: Dictionary = {}

# Középre helyezi a nagyítás tengelyét, az eddigi képernyőpozíció megtartásával.
func _ready() -> void:
	for button: TextureButton in [$beallitas, $folytatas, $iranyitas, $kilepes]:
		# A piros kiemelt képek szélesebbek a normál képeknél.
		# Mindegyiket középre rajzoljuk, így képcserekor sem tolódik el a felirat.
		button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
		_button_scales[button] = button.scale
		var old_origin := button.get_transform().origin
		button.pivot_offset = button.size / 2.0
		# A gombok már eleve kicsinyítettek: a pivot változásának eltolását korrigáljuk.
		button.position += old_origin - button.get_transform().origin
		button.mouse_entered.connect(_set_button_hover.bind(button, true))
		button.mouse_exited.connect(_set_button_hover.bind(button, false))
	visibility_changed.connect(_reset_button_scales)

# Mindig az eredeti méretből számol, így ismételt rámutatáskor sem nő tovább.
func _set_button_hover(button: TextureButton, hovered: bool) -> void:
	button.scale = _button_scales[button] * (HOVER_SCALE if hovered else 1.0)

# Bezáráskor és újranyitáskor törli a korábbi kiemelést.
func _reset_button_scales() -> void:
	for button: TextureButton in _button_scales:
		button.scale = _button_scales[button]

# A setter minden értékadáskor a SceneTree szünetét és a menü láthatóságát is frissíti.
var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		
# Ha az Esc műveletet más kezelő nem fogyasztotta el, átváltja a szünet állapotát.
func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		self.is_paused = !is_paused
		
# Kívülről is beállíthatóvá teszi a szünetet, és hozzáigazítja a menü láthatóságát.
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: beállítások. Előtte hangot játszik le, és egy másodpercet vár.
func _on_beallitas_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/beállítások.tscn")
	
# A gomb megnyomásakor hangot játszik le, majd a szünet és a menü láthatóságát az is_paused ellentétére állítja.
func _on_folytatas_pressed() -> void:
	$buttonpress.play()
	get_tree().paused = !is_paused
	visible = !is_paused
	
# A gomb megnyomásakor megnyitja ezt a jelenetet: menü. Előtte hangot játszik le, és egy másodpercet vár.
func _on_kilepes_pressed() -> void:
	get_tree().paused = !is_paused
	visible = !is_paused
	$buttonpress.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menü.tscn")


# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_beallitas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_folytatas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_iranyitas_mouse_entered() -> void:
	$"Egérrávitel".play()

# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_kilepes_mouse_entered() -> void:
	$"Egérrávitel".play()
