# A stáblista videós bevezetőjét, hangjait és egymást követő animációit vezérli.
extends Node2D

# A bevezetőből hátralévő idő másodpercben; a played megakadályozza az ismételt indítást.
var countdown = 1 
var played = false

# Elindítja a videót és a fehér zajt, közben leállítja a háttérzenét.
func _ready() -> void:
	$VideoStreamPlayer.play()
	$feherzaj.play()
	$"háttérzene".stop()
	
# Csökkenti a visszaszámlálást; lejárat után egyszer átvált a stáblista animációjára és hangjára.
func _process(delta: float) -> void:
	if countdown > 0:
		countdown -= delta
		
	elif !played:
		$AnimationPlayer.play("Credits roll")
		$VideoStreamPlayer.hide()
		$TvHatter.show()
		$AudioStreamPlayer3.play()
		$feherzaj.stop()
		played = true
		
		

# Az első stáblista-animáció után elindítja a másodikat, majd összesen két másodperc múlva megmutatja a gombot.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Credits roll":
		$AnimationPlayer.play("Credits roll_2")
		await get_tree().create_timer(1).timeout
		await get_tree().create_timer(1).timeout
		$TextureButton.show()
