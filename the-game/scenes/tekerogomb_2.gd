# A második tekerőgomb képét forgatja a függőleges egérhúzás alapján; hangértéket nem állít.
extends TextureButton

# Forgásszög fokban; a dragging jelzi, hogy éppen húzzuk-e a gombot.
var angle := 78.0
var dragging := false

# A bal gomb nyomását figyeli; húzás közben az egér függőleges elmozdulását forgatássá alakítja.
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		# A függőleges húzás felét veszi ellenkező előjellel, majd 78–413 fokra korlátozza a szöget.
		var delta_angle = event.relative.y * -0.5
		angle = clamp(angle + delta_angle, 78, 413)
		$goNb2.rotation_degrees = angle
		
