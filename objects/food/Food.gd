extends Area2D

export (Array, StreamTexture) var foodSprites
onready var sprite = $Sprite
onready var player = $"../Player"

signal food_eaten

func _ready():
	var idx = randi() % foodSprites.size()
	var tex = foodSprites[idx]
	sprite.texture = tex
	connect("food_eaten", player, "_on_food_eaten")

func _on_Food_body_entered(body):
	if body == player:
		emit_signal("food_eaten", self)
		queue_free()
