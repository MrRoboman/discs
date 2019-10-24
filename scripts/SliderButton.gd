extends Node2D

var press_position

func _ready():
	pass

func _draw():
	draw_rect(Rect2(0,0,50,50), Color(0,1,0))

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			press_position = event.position
	if event is InputEventScreenDrag:
		if (press_position):
			print(event.position)
			$'../LineEdit'.text = String(event.position.x - press_position.x)