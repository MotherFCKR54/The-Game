extends TextureButton

var angle := 78.0
var dragging := false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed  # Only drag if pressed inside the button
	elif event is InputEventMouseMotion and dragging:
		var delta_angle = event.relative.y * -0.5
		angle = clamp(angle + delta_angle, 78, 413)
		$goNb1.rotation_degrees = angle
