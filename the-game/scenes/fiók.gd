# A fiók kattintható területe: 1,5 másodpercnyi nyomva tartás után kéri a fiók megnyitását.
extends Area2D

# Nyilvántartja, hogy tartjuk-e az egérgombot, és mennyi ideje tart a nyomás.
var nyomva_van = false
var nyomasi_ido = 0.0

# Nyomva tartás közben összegzi a delta másodperceket; 1,5 másodperc után egyszer megnyitja a fiókot.
func _process(delta):
	if nyomva_van:
		nyomasi_ido += delta

		if nyomasi_ido >= 1.5:
			nyomva_van = false
			get_tree().current_scene.fioknyitas()


# A területre érkező bal egérgomb-eseményekből indítja vagy megszakítja a nyomva tartás mérését.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.pressed:
				nyomva_van = true
				nyomasi_ido = 0.0
			else:
				nyomva_van = false
				nyomasi_ido = 0.0
