extends Node2D
class_name Game

onready var screen_size = get_viewport_rect().size
var rng = RandomNumberGenerator.new()

var velocity_clamp = 10
var circles = []

signal created_circle

func _ready():
	rng.randomize()
	create_circle(Vector2(screen_size.x * 0.5, 500), Vector2(0, 0))
	create_circle(Vector2(screen_size.x * 0.5, screen_size.y - 500), Vector2(0, 0))
#	for i in range(1):
#		create_circle()


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
##			print('press')
##			print(event.index)
			# Turn on Debug
			if event.index == 4 or event.position.distance_to(Vector2()) < 20:
				$Debug/ControlPanel.toggle()
			for c in circles:
				c.grab_if_possible(event)
		else:
			for c in circles:
				c.release(event)

	if event is InputEventScreenDrag:
##		print('drag')
##		print(event.index)
		for c in circles:
			c.move(event)


func _physics_process(delta):
	handle_circle_logic(delta)
	pass
	
	
func handle_circle_logic(delta):
	var colliding_pairs = []
	
	# Update circle positions
	for c in circles:
		if c.grabbed:
			var last_position = c.position
			c.position = c.finger_position + c.grabbed_offset
			var velocity_on_last_frame = (c.position - last_position) * c.release_factor
			c.velocity = (c.velocity + velocity_on_last_frame) / 2
			print(c.velocity)
		else:
			c.acceleration = -c.velocity * c.drag
			c.velocity += c.acceleration * delta
			c.position += c.velocity * delta
			
			# Wrap circle that go off screen
			if c.position.x < 0:
				c.position.x += screen_size.x
			if c.position.x > screen_size.x:
				c.position.x -= screen_size.x
			if c.position.y < 0:
				c.position.y += screen_size.y
			if c.position.y > screen_size.y:
				c.position.y -= screen_size.y
			
			# Clamp velocity near zero
			if (c.velocity.length() < velocity_clamp):
				c.velocity = Vector2()
		
	# Static collision ie overlap
	for c1 in circles:
		for c2 in circles:
			if c1.name != c2.name:
				var distance_vector = c1.position - c2.position
				var distance_between_circles = distance_vector.length()
				var radii = c1.radius + c2.radius
				var circles_overlap = distance_between_circles < radii
				if circles_overlap:
					colliding_pairs.push_back([c1, c2])
					
					# Displace balls away from collision
					var overlap = 0.5 * (distance_between_circles - c1.radius - c2.radius)
					var displacement = overlap * distance_vector / distance_between_circles
					# BUG: adding 1px displacement for c1 because `distance_between_circles < radii` evaluates to true even when the values are equal..
					c1.position -= displacement + displacement.normalized() 
					c2.position += displacement
		
	# Dynamic Collision
	for pair in colliding_pairs:
		var c1 = pair[0]
		var c2 = pair[1]
		
		var distance = (c1.position - c2.position).length()
		var normal = (c2.position - c1.position) / distance
		
		# Wikipedia maths
		var k = c1.velocity - c2.velocity
		var p = 2.0 * (normal.x * k.x + normal.y * k.y) / (c1.mass + c2.mass)
		c1.velocity -= Vector2(p,p) * c2.mass * normal
		c2.velocity += Vector2(p,p) * c1.mass * normal
		
		
		# OneLoneCoder maths
#		var tangent = Vector2(-normal.y, normal.x)
#
#		var dot_product_tan_1 = c1.velocity.x * tangent.x + c1.velocity.y * tangent.y
#		var dot_product_tan_2 = c2.velocity.x * tangent.x + c2.velocity.y * tangent.y
#
#		var dot_product_norm_1 = c1.velocity.x * normal.x + c1.velocity.y * normal.y
#		var dot_product_norm_2 = c2.velocity.x * normal.x + c2.velocity.y * normal.y
#
#		var momentum_1 = (dot_product_norm_1 * (c1.mass - c2.mass) + 2.0 * c2.mass * dot_product_norm_2) / (c1.mass + c2.mass)
#		var momentum_2 = (dot_product_norm_2 * (c2.mass - c1.mass) + 2.0 * c1.mass * dot_product_norm_1) / (c1.mass + c2.mass)
#
#		c1.velocity.x = tangent.x * dot_product_tan_1 + normal.x * momentum_1
#		c1.velocity.y = tangent.y * dot_product_tan_1 + normal.y * momentum_1
#		c2.velocity.x = tangent.x * dot_product_tan_2 + normal.x * momentum_2
#		c2.velocity.y = tangent.y * dot_product_tan_2 + normal.y * momentum_2
		
		
		




func _on_GameArea_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
#		$RedDisc.handle_input(event)
		pass
#	if event is InputEventScreenTouch:
#		if event.is_pressed():
#			print('down')
#			$RedDisc.position = event.position
#		else:
#			print('up')
#
#	if event is InputEventScreenDrag:
#		print(event.position)
#		$RedDisc.position = event.position
	pass
	
	
func _on_TopGoal_body_entered(body):
	if body.name == 'Ball':
		$Ball.position = get_viewport_rect().size * 0.5
		$Ball.velocity = Vector2()
		
		
func _on_BottomGoal_body_entered(body):
	if body.name == 'Ball':
		$Ball.position = get_viewport_rect().size * 0.5
		$Ball.velocity = Vector2()



func get_random_position():
	return Vector2(rng.randi_range(0, screen_size.x), rng.randi_range(0, screen_size.y))

func create_circle(position = null, velocity = Vector2(), mass = null):
	var circle = load('res://scenes/Circle.tscn').instance()
	if position != null:
		circle.position = position
	else:
		circle.position = get_random_position()
	circle.velocity = velocity
	if mass != null:
		circle.mass = mass
	add_child(circle)
	circles.push_back(circle)
	emit_signal("created_circle", circle)