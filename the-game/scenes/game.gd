# A játékpálya vezérlője: inventory-kijelzés, automatikus mentés és fióknyitás.
extends Node2D

# A dugvilla állapota és a pálya eredeti háttérképe.
var _lamp_connected := false
var _original_room_texture: Texture2D
# A hosszabbító kapcsolója a dugvilla állapotától függetlenül ki-be kapcsolható.
var _power_strip_on := false
var _power_indicator: Sprite2D

# Előre betölti a fiók jelenetét, hogy megnyitáskor példányosítható legyen.
var fiok_scene = preload("res://scenes/fiók.tscn")

# Felépíti a tárgylista felületét, beköti a frissítést és a pozíciómentést, majd elindítja az időzítőt.
func _ready() -> void:
	var hud := CanvasLayer.new()
	add_child(hud)
	hud.add_child(preload("res://scenes/inventory_bar.gd").new())
	_setup_muzikri_box()
	_setup_plug()
	_setup_power_switch()
	# A mentett állapotot a háttérre, a dugvilla helyére és a jelzőfényre is alkalmazza.
	_lamp_connected = SaveManager.lamp_connected
	_power_strip_on = SaveManager.power_strip_on
	_update_plug_visuals()
	_power_indicator.visible = _power_strip_on
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

# Példányosítja az előre betöltött fiókjelenetet és hozzáadja a pályához.
func fioknyitas():
	if not get_tree().get_nodes_in_group("drawer_view").is_empty():
		return
	var fiok = fiok_scene.instantiate()
	add_child(fiok)

# A háttérképre rajzolt Muzikri dobozhoz kattintható területet ad.
# A képmérethez viszonyított hely a Szoba eltolását és skáláját is követi.
func _setup_muzikri_box() -> void:
	var area := preload("res://scenes/box_pickup.gd").new()
	area.name = "MuzikriDoboz"
	var image_size: Vector2 = $Szoba.texture.get_size()
	area.position = image_size * (Vector2(0.030, 0.821) - Vector2(0.5, 0.5))
	var collision := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = image_size * Vector2(0.047, 0.066)
	collision.shape = rectangle
	area.add_child(collision)
	$Szoba.add_child(area)

# A lógó dugvilla körül hoz létre kattintható területet, a háttér skáláját követve.
func _setup_plug() -> void:
	_original_room_texture = $Szoba.texture
	var area := preload("res://scenes/plug_interaction.gd").new()
	area.name = "Dugvilla"
	var image_size: Vector2 = $Szoba.texture.get_size()
	area.position = image_size * (Vector2(0.881, 0.787) - Vector2(0.5, 0.5))
	var collision := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = image_size * Vector2(0.026, 0.05)
	collision.shape = rectangle
	area.add_child(collision)
	area.activated.connect(_connect_lamp)
	$Szoba.add_child(area)

# Bekötés és kihúzás között vált; a kattintható terület a dugvilla új helyére kerül.
func _connect_lamp() -> void:
	_lamp_connected = not _lamp_connected
	_update_plug_visuals()
	SaveManager.lamp_connected = _lamp_connected
	SaveManager.save_game()

# Betöltéskor is használható, anélkül hogy megfordítaná vagy felülírná a mentett állapotot.
func _update_plug_visuals() -> void:
	# A szerkesztőben látható AnimatedSprite2D csak teljes áramkörnél játszik.
	var animation: AnimatedSprite2D = $Szoba/UVLampa
	if _lamp_connected and _power_strip_on:
		$Szoba.texture = preload("res://newpictures/szoba-withlampa.png")
		animation.show()
		animation.play("uv_villodas")
	else:
		animation.stop()
		animation.hide()
		$Szoba.texture = preload("res://newpictures/szoba-withlampa.png") if _lamp_connected else _original_room_texture
	var plug_position := Vector2(0.905, 0.88) if _lamp_connected else Vector2(0.881, 0.787)
	$Szoba/Dugvilla.position = $Szoba.texture.get_size() * (plug_position - Vector2(0.5, 0.5))
	# Bedugva szűkebb a kattintható terület, hogy ne fedje a szomszédos kapcsolót.
	$Szoba/Dugvilla.get_child(0).shape.size = $Szoba.texture.get_size() * (Vector2(0.012, 0.028) if _lamp_connected else Vector2(0.026, 0.05))

# A hosszabbító bal oldali piros kapcsolójához kattintható területet és jelzőfényt készít.
func _setup_power_switch() -> void:
	var image_size: Vector2 = $Szoba.texture.get_size()
	var area := Area2D.new()
	area.name = "HosszabbitoKapcsolo"
	area.position = image_size * (Vector2(0.8955, 0.881) - Vector2(0.5, 0.5))
	var collision := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = image_size * Vector2(0.007, 0.020)
	collision.shape = rectangle
	area.add_child(collision)
	area.input_event.connect(_on_power_switch_input)
	$Szoba.add_child(area)
	_power_indicator = Sprite2D.new()
	_power_indicator.name = "BekapcsolvaJelzo"
	_power_indicator.texture = preload("res://newpictures/codegatewrong2.png")
	_power_indicator.scale = image_size * Vector2(0.008, 0.014) / _power_indicator.texture.get_size()
	_power_indicator.visible = false
	_power_indicator.z_index = 1
	area.add_child(_power_indicator)

# Egy bal kattintás bekapcsolja a piros jelzést, a következő kikapcsolja.
func _on_power_switch_input(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_power_strip_on = not _power_strip_on
		_update_plug_visuals()
		_power_indicator.visible = _power_strip_on
		SaveManager.power_strip_on = _power_strip_on
		SaveManager.save_game()
		get_viewport().set_input_as_handled()
