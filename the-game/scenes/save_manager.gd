# Minden pályáról elérhető mentéskezelő: pálya, inventory és karakterpozíció egy JSON-fájlban.
extends Node
# Erre a jelzésre frissül a képernyőn látható tárgylista.
signal inventory_changed
# Mentési hibáról értesíti az esetleges további figyelőket.
signal save_failed(message: String)

# A user:// a játék felhasználói adatmappája, nem a projekt forrásmappája.
const SAVE_PATH := "user://progress.json"
# A mentendő pálya res:// útvonala; üres érték esetén még nincs aktív játék.
var current_level: String = ""
# Tárgyazonosító -> darabszám szótár. Módosításhoz az add_item/remove_item függvényeket használd.
var inventory: Dictionary = {}
# Az aktuális karakter referenciája; a mentés innen olvassa a globális pozíciót.
var _player: Node2D
# A betöltött helyet a pálya létrejöttéig tárolja. A null azt jelenti, nincs alkalmazandó pozíció.
var _pending_position: Variant = null
# A mentési hibaüzeneteket megjelenítő ablak referenciája.
var _error_dialog: AcceptDialog

# Szünet közben is aktívvá teszi a kezelőt, és létrehozza a mentési hibák ablakát.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_error_dialog = AcceptDialog.new()
	_error_dialog.title = "Mentés"
	add_child(_error_dialog)

# Kiírja a hibát a Godot naplójába, jelzést küld, és megjelenít egy párbeszédablakot.
func _report(message: String) -> void:
	push_warning(message)
	save_failed.emit(message)
	_error_dialog.dialog_text = message
	_error_dialog.popup_centered()

# Beolvassa és ellenőrzi a mentést. Hiányzó vagy hibás adatnál üres szótárat ad vissza.
func _read_save() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {}
	var data: Variant = parser.data
	if not data is Dictionary:
		return {}
	if data.get("version") != 1 or not data.get("level") is String or not data.get("inventory") is Dictionary:
		return {}
	var level: String = data["level"]
	# A pozíció opcionális, így a korábbi, pozíció nélküli mentések is használhatók.
	if data.has("position"):
		var position_data: Variant = data["position"]
		if not position_data is Array or position_data.size() != 2:
			return {}
		for coordinate: Variant in position_data:
			if not (coordinate is int or coordinate is float):
				return {}
			if not is_finite(float(coordinate)) or abs(float(coordinate)) > 1.0e20:
				return {}
	# Csak létező, projekten belüli jelenetre enged visszatölteni.
	if not level.begins_with("res://") or not level.ends_with(".tscn") or not ResourceLoader.exists(level, "PackedScene"):
		return {}
	# Csak nem üres tárgyazonosítókat és pozitív, egész, korlátozott darabszámokat fogad el.
	for item: Variant in data["inventory"]:
		var amount: Variant = data["inventory"][item]
		if not item is String or item.is_empty():
			return {}
		if not (amount is float or amount is int):
			return {}
		if not is_finite(float(amount)) or amount <= 0 or amount > 2147483647 or amount != floor(amount):
			return {}
	return data

# Megmondja, van-e jelenleg érvényes, betölthető mentés.
func has_save() -> bool:
	return not _read_save().is_empty()

# Kiüríti a memóriában tárolt állapotot; a régi fájl az új pálya megnyitásáig megmarad.
func new_game() -> void:
	current_level = ""
	_player = null
	_pending_position = null
	inventory.clear()
	inventory_changed.emit()

# Regisztrálja a pályát és a karaktert, alkalmazza a betöltésre váró pozíciót, majd ment.
func enter_level(scene_path: String, player: Node2D = null) -> void:
	if scene_path == current_level and _pending_position is Vector2 and is_instance_valid(player):
		player.global_position = _pending_position
		if player is CharacterBody2D:
			# A karakter betöltéskor nem viszi tovább a korábbi mozgási sebességet.
			player.velocity = Vector2.ZERO
	_pending_position = null
	_player = player
	current_level = scene_path
	save_game()

# Ideiglenes fájlba írja az állapotot, majd lecseréli a mentést. Siker esetén true az eredmény.
func save_game() -> bool:
	if current_level.is_empty() or _pending_position != null:
		return false
	# Előbb külön fájl készül, hogy írás közben ne csonkoljuk a meglévő mentést.
	var temp_path := SAVE_PATH + ".tmp"
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		_report("Nem sikerült megnyitni a mentési fájlt.")
		return false
	var data := {"version": 1, "level": current_level, "inventory": inventory}
	if is_instance_valid(_player):
		# A Vector2 koordinátáit két számként tárolja, mert ez közvetlenül JSON-ba írható.
		data["position"] = [_player.global_position.x, _player.global_position.y]
	file.store_string(JSON.stringify(data, "\t"))
	# Kiüríti az írási puffert, majd még bezárás előtt lekérdezi az írási hibát.
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		_report("Nem sikerült kiírni a mentést.")
		return false
	var result := DirAccess.rename_absolute(ProjectSettings.globalize_path(temp_path), ProjectSettings.globalize_path(SAVE_PATH))
	if result != OK:
		_report("Nem sikerült frissíteni a mentést.")
		return false
	return true

# Visszaállítja a mentett adatokat és betölti a pályát. Sikertelen pályaváltásnál visszavonja az állapotcserét.
func continue_game() -> bool:
	var data := _read_save()
	if data.is_empty():
		_report("Nincs betölthető mentés. Indíts új játékot!")
		return false
	# Sikertelen pályaváltás esetére megőrzi a betöltés előtti állapotot.
	var previous_level := current_level
	var previous_inventory := inventory.duplicate()
	var previous_pending: Variant = _pending_position
	var previous_player := _player
	_player = null
	_pending_position = null
	# A pozíció opcionális, így a korábbi, pozíció nélküli mentések is használhatók.
	if data.has("position"):
		_pending_position = Vector2(data["position"][0], data["position"][1])
	current_level = data["level"]
	inventory = {}
	for item: String in data["inventory"]:
		inventory[item] = int(data["inventory"][item])
	var result := get_tree().change_scene_to_file(current_level)
	if result != OK:
		current_level = previous_level
		inventory = previous_inventory
		_player = previous_player
		_pending_position = previous_pending
		_report("A mentett pályát nem sikerült betölteni.")
		return false
	get_tree().paused = false
	inventory_changed.emit()
	return true

# Pozitív darabszámot ad hozzá, értesíti a kijelzőt és ment. Írási hibánál a változás memóriában megmarad.
func add_item(item_id: String, amount: int = 1) -> bool:
	if item_id.strip_edges().is_empty() or amount <= 0 or get_item_count(item_id) > 2147483647 - amount:
		return false
	inventory[item_id] = get_item_count(item_id) + amount
	inventory_changed.emit()
	return save_game()

# Ha van elég tárgy, levonja a darabszámot; nullánál törli a bejegyzést, frissít és ment.
func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0 or get_item_count(item_id) < amount:
		return false
	inventory[item_id] -= amount
	if inventory[item_id] == 0:
		inventory.erase(item_id)
	inventory_changed.emit()
	return save_game()

# Visszaadja a tárgy mennyiségét; ismeretlen azonosítónál nullát ad.
func get_item_count(item_id: String) -> int:
	return int(inventory.get(item_id, 0))
