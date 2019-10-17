extends CanvasLayer

onready var game: Game = $".."

func _ready():
	var nodes: Array = game.get_children()
	for node in nodes:
		if node is Circle:
			write_label(node)
			position_label(node)
