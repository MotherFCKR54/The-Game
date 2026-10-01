# A nyitott fiók tárgyait kezeli; a már elrakott cetli nem jelenik meg újra.
extends CanvasLayer

const NoteReader = preload("res://scenes/note_reader.gd")
var _was_paused := false
var _closing := false

# A fiók külön felületként megállítja a karaktert, és beköti a cetli kattintását.
func _ready() -> void:
	add_to_group("drawer_view")
	process_mode = Node.PROCESS_MODE_ALWAYS
	_was_paused = get_tree().paused
	get_tree().paused = true
	$cetli.pressed.connect(_open_note)
	$vissza.pressed.connect(close)
	SaveManager.inventory_changed.connect(_refresh_note)
	get_viewport().size_changed.connect(_layout)
	_refresh_note()
	_layout()

# Az üres fiók képe kitölti a képernyőt; a cetli a belsejében helyezkedik el.
func _layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	$fiok.size = viewport_size
	$cetli.size = viewport_size * Vector2(0.26, 0.28)
	$cetli.position = viewport_size * Vector2(0.57, 0.39)
	$cetli.pivot_offset = $cetli.size / 2

# Mentésből visszatöltött inventory esetén is eltünteti a már felvett tárgyat.
func _refresh_note() -> void:
	$cetli.visible = SaveManager.get_item_count("cetli") == 0

# Ugyanazt az olvasónézetet nyitja, amelyet az inventory is használ.
func _open_note() -> void:
	if not get_tree().get_nodes_in_group("note_reader").is_empty():
		return
	add_child(NoteReader.new())

# Az olvasó felett nem zárjuk be a fiókot; egyébként Esc-kel is visszaléphetünk.
func _input(event: InputEvent) -> void:
	if not get_tree().get_nodes_in_group("note_reader").is_empty():
		return
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		close()

# Visszaadja a vezérlést a játéknak, és eltávolítja a fiók felületét.
func close() -> void:
	if _closing:
		return
	_closing = true
	get_tree().paused = _was_paused
	queue_free()
