# A háttérvideót automatikusan elindítja, amikor a node készen áll.
extends VideoStreamPlayer


# Amikor a videó node készen áll, elindítja a lejátszást.
func _ready() -> void:
	play()
