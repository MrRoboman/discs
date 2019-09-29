extends Node2D
class_name Game

onready var screen_size = get_viewport_rect().size

var velocity_clamp = 10
var circles = []

signal created_circle

var red_score = 0
var blue_score = 0
var ball

func _ready():
	randomize()
	# Small Blue
	create_circle({
		'position': Vector2(screen_size.x * 0.5, 300),
		'radius': 70,
		'drag': 1,
		'release_factor': 40,
		'color': '#0000ff',
		'is_player': true,
	})
	# Small Red
	create_circle({
		'position': Vector2(screen_size.x * 0.5, screen_size.y - 300),
		'radius': 70,
		'drag': 1,
		'release_factor': 40,
		'is_player': true,
	})
	# White Ball
	ball = create_circle({
		'grabbable': false,
		'position': screen_size * 0.5,
		'color': '#ffffff',
		'radius': 100,
		'mass': 100,
		'can_collect': false,
		'is_ball': true,
	})
	# Big Blue
#	create_circle({
#		'position': Vector2(randf() * screen_size.x, randf() * screen_size.y),
#		'color': '#0000ff',
#		'radius': 300,
#		'mass': 600,
#		'drag': 1,
#		'release_factor': 10,
#		'collectible': true,
#	})
	var margin_x = 400
	var margin_y = 400
	var rows = 8
	var cols = 5
	var x = margin_x
	var y = margin_y
	var i = 0
	while x < screen_size.x - margin_x:
		while y < screen_size.y - margin_y:
			create_circle({
				'position': Vector2(x,y),
				'radius': 30,
				'color': '#00ff00',
				'is_collectible': true,
				'mass': 200,
			})
			i += 1
			print(i)
			y += screen_size.y / rows
		x += screen_size.x / cols
		y = margin_y
		
	
	# Blurp
#	for i in range(50):
#		create_circle({
#			'position': Vector2(400,400),
#			'radius': 30,
#			'color': '#00ff00',
#			'is_collectible': true,
#		})
	
# Corners!
#	var margin = 50
#	var rows = 20
#	var cols = 10
#	var x = 0
#	var y = 0
#	while x < screen_size.x:
#		while y < screen_size.y:
#			create_circle({
#				'position': Vector2(margin + screen_size.x / (x+1), margin + screen_size.y / (y+1)),
#				'radius': 30,
#				'color': '#00ff00',
#				'is_collectible': true,
#			})
#			y += 250
#		x += 250
#		y = 0

func get_random_position() -> Vector2:
	return Vector2(randf() * screen_size.x, randf() * screen_size.y)

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if event.index == 4 or event.position.distance_to(Vector2()) < 20:
				$Debug/ControlPanel.toggle()
			
			for c in circles:
				c.grab_if_possible(event)
		else: # Unpressed
			for c in circles:
				c.release(event)

	if event is InputEventScreenDrag:
		for c in circles:
			c.move(event)


func _physics_process(delta):
	handle_circle_logic(delta)
	pass
	
var top_speed = Vector2()
func handle_circle_logic(delta):
	var colliding_pairs = []
	
	# Update circle positions
	for c in circles:
		if c.grabbed:
			var last_position = c.position
			c.position = c.finger_position + c.grabbed_offset
			var velocity_on_last_frame = (c.position - last_position) * c.release_factor
			c.velocity = (c.velocity + velocity_on_last_frame) / 2
		else:
			if c.velocity.length() > top_speed.length():
				top_speed = c.velocity
				print(top_speed.length())
			c.acceleration = -c.velocity * c.drag
			c.velocity += c.acceleration * delta
			c.position += c.velocity * delta
			
			# Wrap circle that go off screen
#			if c.position.x < 0:
#				c.position.x += screen_size.x
#			if c.position.x > screen_size.x:
#				c.position.x -= screen_size.x
#			if c.position.y < 0:
#				c.position.y += screen_size.y
#			if c.position.y > screen_size.y:
#				c.position.y -= screen_size.y

			# Bounce off screen edge
			# NOTE: changing velocity here feels like no-no
			if c.position.x - c.radius < 0:
				c.position.x = c.radius
				c.velocity.x = -c.velocity.x
			if c.position.x + c.radius > screen_size.x:
				c.position.x = screen_size.x - c.radius
				c.velocity.x = -c.velocity.x
			if c.position.y - c.radius < 0:
				c.position.y = c.radius
				c.velocity.y = -c.velocity.y
			if c.position.y + c.radius > screen_size.y:
				c.position.y = screen_size.y - c.radius
				c.velocity.y = -c.velocity.y
			
			# Clamp velocity near zero
			if (c.velocity.length() < velocity_clamp):
				c.velocity = Vector2()
		
	# Static collision ie overlap
	for c1 in circles:
		if c1.velocity.x == 0 and c1.velocity.y == 0:
			continue
		for c2 in circles:
			# Visibility stuff is temp for collectibles (maybe?)
			if c1.name != c2.name and c1.visible and c2.visible:
				var distance_vector = c1.position - c2.position
				var distance_between_circles = distance_vector.length()
				var radii = c1.radius + c2.radius
				var circles_overlap = distance_between_circles < radii
				if circles_overlap:
					# Ball stuff
					c1.ball_collide(c2)
					
					# Collectibles
					var collected:bool = c1.collect(c2)
					if collected:
						if ball.color == '#ff0000':
							red_score += 1
							$CanvasLayer/RedLabel.text = String(red_score)
						if ball.color == '#0000ff':
							blue_score += 1
							$CanvasLayer/BlueLabel.text = String(blue_score)
						continue
					
					if not c1.grabbed and not c2.grabbed:
						colliding_pairs.push_back([c1, c2])
					
					# Displace balls away from collision
					var overlap = 0.5 * (distance_between_circles - c1.radius - c2.radius)
					var displacement = overlap * distance_vector / distance_between_circles
					# BUG: adding 1px displacement for c1 because `distance_between_circles < radii` evaluates to true even when the values are equal..
					if c2.grabbed:
						c2.grabbed_offset -= displacement
					else:
						c1.position -= displacement + displacement.normalized() 
					if c1.grabbed:
						c1.grabbed_offset -= displacement
					else:
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

func new_circle(props:Dictionary = {}) -> Circle:
	var circle = load('res://scenes/Circle.tscn').instance()
	for key in props.keys():
		var val = props[key]
		circle.set(key, val)
	return circle

func create_circle(props:Dictionary = {}) -> Circle:
	var circle:Circle = new_circle(props)
	add_child(circle)
	circles.push_back(circle)
	emit_signal("created_circle", circle)
	return circle