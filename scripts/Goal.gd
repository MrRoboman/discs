extends Area2D

var BALL_RADIUS = 50

func _ready():
	pass

func _draw():
	var radius = $CollisionShape2D.shape.get('radius')
	draw_circle(Vector2(), BALL_RADIUS + 42, Color(1,1,1))
	draw_circle(Vector2(), BALL_RADIUS + 40, Color(0,0,0))
