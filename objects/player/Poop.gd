extends Area2D

onready var sprite = $Sprite
onready var fart_audio = $FartAudio
onready var player = $"../RootNode2D/Player"

var playerExited = false

export (Array, Texture) var footstepSprites

signal poop_eaten

func _ready():
	draw_footstep()
	play_fart_audio()
	
	connect("poop_eaten", player, "_on_poop_eaten")

func draw_footstep():
	var footstepIdx = randi() % footstepSprites.size()
	var footstepTex = footstepSprites[footstepIdx]
	
	sprite.texture = footstepTex
	rotation_degrees = randi() % 360

func play_fart_audio():
	fart_audio.play()

func _on_Poop_body_entered(body):
	if (body == player && playerExited):
		emit_signal("poop_eaten", self)
		queue_free()

func _on_Poop_body_exited(body):
	if (body == player):
		playerExited = true
