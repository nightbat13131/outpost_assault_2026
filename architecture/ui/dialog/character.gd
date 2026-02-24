class_name Character extends Resource

const ANIMATION_TALK  = 'talk'
const ANIMATION_IDLE  = 'default'

# TODO: add background? 

@export var background : Texture2D
@export var sprite : SpriteFrames
@export var talking_sound: AudioStream
@export var _name : String

func get_background() -> Texture2D:
	return background

func get_sprites() -> SpriteFrames: return sprite

func get_talk_audio() -> AudioStream: return talking_sound

func get_character_name() -> String: return _name
