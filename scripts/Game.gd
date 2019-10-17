extends Node2D
class_name Game

#var QuadTree = preload('res://scripts/QuadTree.gd')
signal created_circle

onready var screen_size = get_viewport_rect().size

var velocity_clamp = 100 # Compares to velocity.length_squared()
var circles = []
var discs = []
var collisions = []

var red_score = 0
var blue_score = 0
var quad_tree

var ball
var top_disc
var bottom_disc
var top_goal
var bottom_goal

var forward_slingshot = false

var PLAYER_ZONE = 600

var firebase

#func _draw():
#	if quad_tree:
#		var rects = quad_tree.get_rects()
#		for rect in rects:
##			print(rect)
#			draw_rect(rect, Color(1,1,0,.1))
func on_request_completed(response):
#	print(response['games'])
	var data:Dictionary = response
	print(data)
	firebase.disconnect('request_completed', self, 'on_request_completed')

func _ready():
#	firebase = get_node('/root/Firebase')
#	firebase.connect('request_completed', self, 'on_request_completed')
#	firebase.load_data()

#	firebase.load_data($HTTPRequest)
#	firebase.save_circle($HTTPRequest, {
#		'name': 'dingle',
#		'x': 100,
#		'y': '200',
#		'is_grabbed': true,
#	})
	
#	firebase.save_circle('Big Boy', {'x':0})
#	firebase.save_game('SHockey', {'y': 'not'})
	
	randomize()
	quad_tree = QuadTree.new().init(screen_size * 0.5, screen_size.x, screen_size.y, circles, 4)
	
#	top_goal = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.15),
#		'og_radius': 194,
##		'color': '#00ffff',
#		'name': 'loon',
#		'is_goal': true,
#		'is_grabbable': false,
#		'texture': "res://assets/plaid.png",
#		'sprite_offset': Vector2(12, 0),
#	})
#	top_goal.modulate = Color(1,1,1,0.5)
#	bottom_goal = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.85),
#		'og_radius': 194,
##		'color': '#ff00ff',
#		'name': 'loon',
#		'is_goal': true,
#		'is_grabbable': false,
#		'texture': "res://assets/polkadot.png",
#		'sprite_offset': Vector2(12, 0),
#	})
#	bottom_goal.modulate = Color(1,1,1,0.5)
#	create_circle({
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'og_radius': 100,
#		'color': '#00ff00',
#		'name': 'powerup',
#		'is_powerup': true,
#	})
#	create_circle({
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'og_radius': 100,
#		'color': '#ff0000',
#		'name': 'powerup',
#		'is_powerdown': true,
#	})
#	create_circle({
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'og_radius': 100,
#		'color': '#ffffff',
#		'name': 'powerup',
#		'is_neutral': true,
#	})
#	ball = create_circle({
#		'position': screen_size * 0.5,
#		'og_radius': 56,
##		'color': '#ffffff',
#		'name': 'ball',
#		'is_ball': true,
#		'is_grabbable': false,
#		'texture': "res://assets/eight.png",
#	})
#	top_disc = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.4),
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'position': screen_size * 0.5,
#		'og_radius': 56,
#		'max_radius': 150,
#		'color': '#ffffff',
#		'name': 'que',
##		'is_slingshot': true,
#		'release_factor': 120,
#		'texture': "res://assets/cue_plaid.png",
#		'drag': .1,
#	})
#	bottom_disc = create_circle({
##		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.6),
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'og_radius': 56,
#		'max_radius': 120,
##		'color': '#ffffff',
#		'name': 'que',
#		'is_slingshot': true,
#		'texture': "res://assets/cue_polkadot.png",
#	})
	var controls = $Debug/ControlPanel/Controls
#	for control in controls.get_children():
#		control.setup()
		
		
	# Small Blue
#	create_disc({
#		'position': Vector2(screen_size.x * 0.5 - 50, 300),
#		'radius': 70,
#		'drag': 1,
#		'release_factor': 40,
#		'color': '#0000ff',
#		'is_player': true,
#		'name': 'blue',
#	})

	# Small Red
#	create_disc({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y - 300),
#		'radius': 70,
#		'drag': 1,
#		'release_factor': 40,
#		'is_player': true,
#		'name': 'red'
#	})
	# White Ball
#	ball = create_disc({
#		'grabbable': false,
#		'position': screen_size * 0.5,
##		'position': Vector2(screen_size.x/2, 900),
#		'color': '#ffffff',
#		'radius': 100,
#		'mass': 100,
#		'can_collect': false,
#		'is_ball': true,
#	})
	
#	for x in range(30):
#		create_disc({
#			'position': Vector2(randf() * screen_size.x, randf() * screen_size.y),
#		})

#	create_circle({
#		'grabbable': false,
##		'position': screen_size * 0.5,
#		'position': Vector2(200, 900),
#		'color': '#ffffff',
#		'radius': 100,
#		'mass': 100,
#		'can_collect': false,
#		'is_ball': true,
#	})
#	create_circle({
#		'grabbable': false,
##		'position': screen_size * 0.5,
#		'position': Vector2(200, 400),
#		'color': '#ffffff',
#		'radius': 100,
#		'mass': 100,
#		'can_collect': false,
#		'is_ball': true,
#	})
#	create_circle({
#		'grabbable': false,
##		'position': screen_size * 0.5,
#		'position': Vector2(500, 400),
#		'color': '#ffffff',
#		'radius': 100,
#		'mass': 100,
#		'can_collect': false,
#		'is_ball': true,
#	})
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

	# Gems
#	var margin_x = 300
#	var margin_y = 500
#	var rows = 8
#	var cols = 6
#	var x = margin_x
#	var y = margin_y
#	var i = 0
#	while x < screen_size.x - margin_x:
#		while y < screen_size.y - margin_y:
#			create_disc({
#				'position': Vector2(x,y),
#				'radius': 30,
#				'color': '#00ff00',
#				'is_collectible': true,
#				'mass': 200,
#			})
##			i += 1
##			print(i)
#			y += screen_size.y / rows
#		x += screen_size.x / cols
#		y = margin_y
		
#	quad_tree = QuadTree.new().init(screen_size * 0.5, screen_size.x, screen_size.y, circles, 2)
#	quad_tree.print_tree()
	
	#var node_grps = quad_tree.get_node_groups()
#	for grp in node_grps:
#		print(grp)
#	update()
	
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

func _draw():
#	draw_rect(Rect2(0, 0, screen_size.x, PLAYER_ZONE), Color('#5DADE2'))
#	draw_rect(Rect2(0, screen_size.y - PLAYER_ZONE, screen_size.x, PLAYER_ZONE), Color('#F1948A'))
	pass

func get_random_position() -> Vector2:
	return Vector2(randf() * screen_size.x, randf() * screen_size.y)

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if event.index == 4 or event.position.distance_to(Vector2()) < 20:
				$Debug/ControlPanel.toggle()

#			create_or_grab_circle(event)
			for c in circles:
				c.grab_if_possible(event)
			
#			ball.velocity = (bottom_disc.position - ball.position)
		else: # Unpressed
			for c in circles:
				c.release(event)
				pass

	if event is InputEventScreenDrag:
		var moved_circle
		for c in circles:
			moved_circle = c.move(event)
#			if moved_circle and not (point_in_rect(event.position, get_bottom_zone()) or point_in_rect(event.position, get_top_zone())):
#				moved_circle.release(event)

func point_in_rect(vec2, rect):
	return vec2.x > rect.position.x and vec2.x < rect.end.x and vec2.y > rect.position.y and vec2.y < rect.end.y

func handle_rect_tap(event):
	if event.position.y > $BottomArea.position.y - $BottomArea/CollisionShape2D.shape.get('extents').y:
		var can_create = true
		for c in circles:
			if c.position.y + c.radius > $BottomArea.position.y - $BottomArea/CollisionShape2D.shape.get('extents').y:
				c.grab_if_possible(event)
				can_create = false
		
		if can_create:
			var circle = create_circle({
				'position': event.position,
				'radius': 70,
				'drag': 1,
				'release_factor': 60,
				'is_player': true,
				'name': 'red',
			})
			circle.grab_if_possible(event)

func _physics_process(delta):
	handle_circle_logic(delta)
	pass

func get_circle_rect(circle):
	return Rect2(circle.position.x - circle.radius, circle.position.y - circle.radius, circle.radius * 2, circle.radius * 2)
	
func circle_in_zone(circle, rect):
	var circle_rect = get_circle_rect(circle)
	return circle_rect.position.x < rect.end.x and circle_rect.end.x > rect.position.x and circle_rect.position.y < rect.end.y and circle_rect.end.y > rect.position.y 
	
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
			c.acceleration = -c.velocity * c.drag
			c.velocity += c.acceleration * delta
			c.position += c.velocity * delta
			
#			if not c.in_play:
#				if not (circle_in_zone(c, get_top_zone()) or circle_in_zone(c, get_bottom_zone())):
#					c.in_play = true
			
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
			if c.in_play:
				if c.position.y - c.radius < get_top_zone().end.y:
					c.position.y = get_top_zone().end.y + c.radius
					c.velocity.y = -c.velocity.y
				if c.position.y + c.radius > get_bottom_zone().position.y:
					c.position.y = get_bottom_zone().position.y - c.radius
					c.velocity.y = -c.velocity.y
			else:
				if c.position.y - c.radius < 0:
					c.position.y = c.radius
					c.velocity.y = -c.velocity.y
				if c.position.y + c.radius > screen_size.y:
					c.position.y = screen_size.y - c.radius
					c.velocity.y = -c.velocity.y
			
			# Clamp velocity near zero
			if (c.velocity.length_squared() < velocity_clamp):
				c.velocity = Vector2()
		
	# Static collision ie overlap
#	var checks = 0
	quad_tree.add_nodes(circles)
	var circle_groups = quad_tree.get_node_groups()
	for circle_group in circle_groups:
		for c1 in circle_group:
#			if c1.velocity.x == 0 and c1.velocity.y == 0:
#				continue
			for c2 in circle_group:
#				checks += 1
				# Visibility stuff is temp for collectibles (maybe?)
				if c1.name != c2.name and c1.visible and c2.visible:
	#				var distance_vector = c1.position - c2.position
	#				var distance_between_circles = distance_vector.length()
	#				var radii = c1.radius + c2.radius
	#				var circles_overlap = distance_between_circles < radii
#					if c1.overlaps_goal(c2):
#						print('win')
#						continue
					
					if (c1.has_velocity() or c2.has_velocity()) and c1.overlaps(c2):
						# Ball stuff
						c1.ball_collide(c2)
						c1.powerup_collide(c2)
						c1.powerdown_collide(c2)
						
						# Collectibles
#						var collected:bool = c1.collect(c2)
#						if collected:
#							if ball.color == '#ff0000':
#								red_score += 1
#								$CanvasLayer/RedLabel.text = String(red_score)
#							if ball.color == '#0000ff':
#								blue_score += 1
#								$CanvasLayer/BlueLabel.text = String(blue_score)
#							continue
						
						colliding_pairs.push_back([c1, c2])
						
						# Displace balls away from collision
						var distance_vector = c1.position - c2.position
						var distance_between_circles = distance_vector.length()
						var overlap = 0.5 * (distance_between_circles - c1.radius - c2.radius)
						var displacement = overlap * distance_vector / distance_between_circles
						# BUG: adding 1px displacement for c1 because `distance_between_circles < radii` evaluates to true even when the values are equal..
#						if c2.grabbed:
#							c2.grabbed_offset -= displacement
#						else:
#							c1.position -= displacement + displacement.normalized() 
#						if c1.grabbed:
#							c1.grabbed_offset -= displacement
#						else:
#							c2.position += displacement
						c1.position -= displacement
						c2.position += displacement
	quad_tree.clear()
#	print(checks)	
	# Dynamic Collision
	for pair in colliding_pairs:
		var c1 = pair[0]
		var c2 = pair[1]
		
		var distance = (c1.position - c2.position).length()
		var normal = (c2.position - c1.position) / distance
		
		# Wikipedia maths
		var k = c1.velocity - c2.velocity
		var p = 2.0 * (normal.x * k.x + normal.y * k.y) / (c1.mass + c2.mass)
		if not c1.grabbed:
			c1.velocity -= Vector2(p,p) * c2.mass * normal
		if not c2.grabbed:
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

func create_disc(props:Dictionary = {}) -> Disc:
	var disc:Disc = load('res://scenes/Disc.tscn').instance()
	var fart = 900
	disc.velocity = Vector2(rand_range(-fart, fart), rand_range(-fart, fart))
	for key in props.keys():
		var val = props[key]
		disc.set(key, val)
	add_child(disc)
	discs.push_back(disc)
	emit_signal("created_disc", disc)
	return disc
	
func handle_disc_collisions():
	for c in collisions:
		var c1 = c[0]
		var collision = c[1]
		var c2 = collision.collider
		if c1.get('mass') and c2.get('mass'):
			var distance = (c1.position - c2.position).length()
			var normal = (c2.position - c1.position) / distance

			# Wikipedia maths
			var k = c1.velocity - c2.velocity
			var p = 2.0 * (normal.x * k.x + normal.y * k.y) / (c1.mass + c2.mass)
			c1.velocity -= Vector2(p,p) * c2.mass * normal
			c2.velocity += Vector2(p,p) * c1.mass * normal
		else:
			c1.velocity = c1.velocity.bounce(collision.normal)
	collisions = []
	
func add_collision(object, collision):
	collisions.push_back([object, collision])
	pass


func get_top_zone():
	return Rect2(0, 0, screen_size.x, PLAYER_ZONE)

func get_bottom_zone():
	return Rect2(0, screen_size.y - PLAYER_ZONE, screen_size.x, PLAYER_ZONE)

func get_in_play_zone():
	return Rect2(0, PLAYER_ZONE, screen_size.x, screen_size.y - PLAYER_ZONE * 2)

func create_or_grab_circle(event):
	var top_zone = get_top_zone()
	var bottom_zone = get_bottom_zone()
	var zone
	var color
	if top_zone.has_point(event.position):
		zone = top_zone
		color = '#0088ff'
	elif bottom_zone.has_point(event.position):
		zone = bottom_zone
		color = '#ff0000'
	
	if zone:
		for c in circles:
			if not c.in_play and zone.has_point(c.position):
				c.grab_if_possible(event)
				return c
		var new_circle = create_circle({
			'position': event.position,
			'radius': 70,
			'drag': 1,
			'release_factor': 60,
			'is_player': true,
			'name': 'circle',
			'color': color,
		})
		new_circle.grab_if_possible(event)
		return new_circle
	
	return null

func _on_BottomArea_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if event.index == 4 or event.position.distance_to(Vector2()) < 20:
				$Debug/ControlPanel.toggle()
			
			var can_create = true
			var grabbed_circle
			for c in circles:
				if c.position.y + c.radius > $BottomArea.position.y - $BottomArea/CollisionShape2D.shape.get('extents').y:
					c.grab_if_possible(event)
					can_create = false
			
			if can_create:
				var circle = create_circle({
					'position': event.position,
					'radius': 70,
					'drag': 1,
					'release_factor': 60,
					'is_player': true,
					'name': 'red',
				})
				circle.grab_if_possible(event)
		else: # Unpressed
			for c in circles:
				c.release(event)

	if event is InputEventScreenDrag:
		for c in circles:
			c.move(event)



func _on_Button_button_down():
	top_goal.position = Vector2(screen_size.x * 0.5, screen_size.y * 0.15)
	top_goal.velocity = Vector2()
	top_goal.health = top_goal.max_health
	
	bottom_goal.position = Vector2(screen_size.x * 0.5, screen_size.y * 0.85)
	bottom_goal.velocity = Vector2()
	bottom_goal.health = bottom_goal.max_health
	
	ball.position = screen_size * 0.5
	ball.velocity = Vector2()
	
	top_disc.position = Vector2(screen_size.x * 0.5, screen_size.y * 0.4)
	top_disc.velocity = Vector2()
	
	bottom_disc.position = Vector2(screen_size.x * 0.5, screen_size.y * 0.6)
	bottom_disc.velocity = Vector2()
	
#	top_goal = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.15),
#		'og_radius': 194,
#		'color': '#00ffff',
#		'name': 'loon',
#		'is_goal': true,
#		'is_grabbable': false,
#		'texture': "res://assets/plaid.png",
#		'sprite_offset': Vector2(12, 0),
#	})
#	bottom_goal = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.85),
#		'og_radius': 194,
#		'color': '#ff00ff',
#		'name': 'loon',
#		'is_goal': true,
#		'is_grabbable': false,
#		'texture': "res://assets/polkadot.png",
#		'sprite_offset': Vector2(12, 0),
#	})
#	ball = create_circle({
#		'position': screen_size * 0.5,
#		'og_radius': 56,
#		'color': '#ffffff',
#		'name': 'ball',
#		'is_ball': true,
#		'is_grabbable': false,
#		'texture': "res://assets/eight.png",
#	})
#	top_disc = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.4),
#		'og_radius': 56,
#		'color': '#ffffff',
#		'name': 'que',
#		'is_slingshot': true,
#		'texture': "res://assets/que.png",
#	})
#	bottom_disc = create_circle({
#		'position': Vector2(screen_size.x * 0.5, screen_size.y * 0.6),
#		'og_radius': 56,
#		'color': '#ffffff',
#		'name': 'que',
#		'is_slingshot': true,
#		'texture': "res://assets/que.png",
#	})


func _on_CheckBox_toggled(button_pressed):
	forward_slingshot = button_pressed

func overlaps_other_circle(circle):
	for c in circles:
		if circle.name != c.name and circle.overlaps(c):
			return true
	return false

func _on_PowerupTimer_timeout():
#	var circle = create_circle({
#		'position':  Vector2(screen_size.x * randf(), screen_size.y * randf()),
#		'og_radius': 56,
#		'color': '#00ff00',
#		'name': 'powerup',
#		'is_powerup': true,
#	})
#	var attempts = 10
#	while (overlaps_other_circle(circle) and attempts > 0):
#		circle.position = Vector2(screen_size.x * randf(), screen_size.y * randf())
#		attempts -= 1
	pass



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print(response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	pass # Replace with function body.
