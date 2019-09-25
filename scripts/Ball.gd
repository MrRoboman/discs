extends 'res://scripts/CircleCollider.gd'

func _draw():
	draw_circle(Vector2(), $CollisionShape2D.shape.get('radius'), Color(1,1,1))

func _physics_process(delta):
	_handle_movement(delta)