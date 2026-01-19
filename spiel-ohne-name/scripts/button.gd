extends Node2D

signal pressed
signal button_down
signal button_up
signal toggled

var total_scale: Vector2 = Vector2(1.0, 1.0);


func _on_texture_button_button_down() -> void:
	button_up.emit();


func _on_texture_button_button_up() -> void:
	button_up.emit();


func _on_texture_button_pressed() -> void:
	pressed.emit();


func _on_texture_button_toggled(toggled_on: bool) -> void:
	toggled.emit();


func set_text(text: String, scale_text_to_fit: bool = true, scale_button_to_fit: bool = false) -> void:
	$TextureButton.scale = total_scale;
	$RichTextLabel.scale = total_scale;
	$RichTextLabel.text = text;
	var text_width = $RichTextLabel.size.x;
	var button_width = $TextureButton.size.x;
	if (scale_text_to_fit):
		$RichTextLabel.scale = Vector2(button_width / text_width, button_width / text_width) * total_scale;
	if (scale_button_to_fit):
		$TextureButton.scale = Vector2(text_width / button_width, text_width / button_width) * total_scale;	
		
func scale(vec: Vector2) -> void:
	$RichTextLabel.scale = vec * $RichTextLabel.scale;
	$TextureButton.scale = vec * $TextureButton.scale;
	total_scale = vec;
