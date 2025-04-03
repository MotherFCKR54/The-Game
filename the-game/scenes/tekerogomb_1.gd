extends TextureButton

var angle := 0.0
var dragging := false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed  # Start/stop dragging
	elif event is InputEventMouseMotion and dragging:
		var delta_angle = event.relative.x * 0.5  # Adjust sensitivity
		angle += delta_angle
		$goNb1.rotation_degrees = angle
