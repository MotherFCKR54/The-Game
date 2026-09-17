extends TextureButton

func _pressed():
	get_parent().queue_free()
