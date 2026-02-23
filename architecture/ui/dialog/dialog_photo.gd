class_name DialogPhoto extends TextureRect

func set_photo(photo: Texture2D) -> void:
	set_texture(photo)

func deactivate() -> void:
	set_texture(null)
