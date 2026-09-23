# A hangbeállítások Mentés gombjának hangjelzései. Az értékeket a hangok.gd alkalmazza.
extends TextureButton

# A gomb megnyomásakor kattintási hangot játszik le; itt más művelet még nincs bekötve.
func _on_pressed() -> void:
	$"../../AudioStreamPlayer".play()
	
# Az egér gomb fölé érkezésekor lejátssza a rámutatás hangját.
func _on_mouse_entered() -> void:
	
	$"../../AudioStreamPlayer2".play()
