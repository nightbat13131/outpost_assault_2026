class_name DisplayCharacter extends Node2D

const BACKGROUND_SIZE = Vector2(128, 128)

@onready var photo_background: Sprite2D = %PhotoBackground
@onready var animated_character: AnimatedSprite2D = %AnimatedCharacter
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

func set_character(character: Character) -> void:
	if character:
		photo_background.set_texture(character.get_background())
		_scale_background()
		animated_character.set_sprite_frames(character.get_sprites())
		audio_stream_player.set_stream(character.get_talk_audio())
	else:
		photo_background.set_texture(null)
		animated_character.set_sprite_frames(null)
		audio_stream_player.set_stream(null)

func _scale_background() -> void:
	var new_scale = Vector2.ONE
	var back_size = photo_background.get_texture().get_size()
	new_scale.x = BACKGROUND_SIZE.x / back_size.x
	new_scale.y = BACKGROUND_SIZE.y / back_size.y
	if new_scale.x > new_scale.y:
		new_scale.y = new_scale.x
	elif new_scale.y > new_scale.x:
		new_scale.x = new_scale.y
	photo_background.set_scale(new_scale)

func talk_start() -> void:
	if animated_character.get_sprite_frames():
		animated_character.play(Character.ANIMATION_TALK)
	if audio_stream_player.get_stream():
		audio_stream_player.play()

func talk_end() -> void:
	if animated_character.get_sprite_frames():
		animated_character.play(Character.ANIMATION_IDLE)
	if audio_stream_player.get_stream():
		audio_stream_player.stop()
