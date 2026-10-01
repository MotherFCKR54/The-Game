# A játékpálya vezérlője: inventory-kijelzés, automatikus mentés és fióknyitás.
extends Node2D

# Előre betölti a fiók jelenetét, hogy megnyitáskor példányosítható legyen.
var fiok_scene = preload("res://scenes/fiók.tscn")

# Felépíti a tárgylista felületét, beköti a frissítést és a pozíciómentést, majd elindítja az időzítőt.
func _ready() -> void:
	var hud := CanvasLayer.new()
	add_child(hud)
	hud.add_child(preload("res://scenes/inventory_bar.gd").new())
	_setup_muzikri_box()
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