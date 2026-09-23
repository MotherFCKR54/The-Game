# A fiók bezárógombja: eltávolítja a gomb szülőjét, vagyis a megnyitott fiók nézetét.
extends TextureButton

# A gomb megnyomásakor törlésre jelöli a szülő node-ot, ezzel bezárja a fiókot.
func _pressed():
	get_parent().queue_free()
