extends Node2D

var countdown = 1 
var played = false

func _ready() -> void:
	$VideoStreamPlayer.play()
	
func _process(delta: float) -> void:
	if countdown > 0:
		countdown -= delta
		
	elif !played:
		$AnimationPlayer.play("Credits roll")
		$VideoStreamPlayer.hide()
		$TvHatter.show()
		$TextureButton.show()
		played = true
		
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Credits roll":
		$AnimationPlayer.play("Credits roll_2")
