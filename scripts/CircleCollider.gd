extends KinematicBody2D

export (float) var mass = 10
export var drag = .99
export var spring = 1
var acceleration = Vector2()
var velocity = Vector2()


func get_radius():
	return $CollisionShape2D.shape.get('radius')

func is_overlapping(other):
	return (position - other.position).length() < get_radius() + other.get_radius()

func _handle_movement(delta):
	velocity *= drag
	if velocity.length() < .01:
		velocity = Vector2()
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		
		var other = collision.collider
		if other.get('mass'):
			var k = position - other.position
			if (is_overlapping(other)):
				print('overlap')
				var distance = k.length()
				var overlap = .5 * (distance - get_radius() - other.get_radius())
				position -= overlap * k / distance
				other.position += overlap * k / distance
			var p = 2.0 * collision.normal.dot(k) / (mass + other.mass)
			velocity -= Vector2(p,p) * other.mass * collision.normal * other.spring
			other.velocity -= Vector2(p,p) * mass * collision.normal * spring

