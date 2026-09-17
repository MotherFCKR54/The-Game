extends Area2D

var nyomva_van = false
var nyomasi_ido = 0.0

func _process(delta):
	if nyomva_van:
		nyomasi_ido += delta

		if nyomasi_ido >= 1.5:
			nyomva_van = false
			get_tree().current_scene.fioknyitas()


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.pressed:
				nyomva_van = true
				nyomasi_ido = 0.0
			else:
				nyomva_van = false
				nyomasi_ido = 0.0
