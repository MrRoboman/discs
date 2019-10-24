extends Node2D
class_name Play


onready var screen_size = get_viewport_rect().size
onready var Tap = get_node('/root/Tap')
var tap_index:int = -1


func input(event):
	if Tap.is_down(event):
		for d in get_discs():
			d.tap(event)
	
	if Tap.is_up(event):
		for d in get_discs():
			d.untap(event)
	
	if Tap.is_drag(event):
		for d in get_discs():
			d.drag(event)


func _physics_process(delta):
	handle_disc_logic(delta)

func get_discs():
	return get_children()


func add_disc(props:Dictionary = {}):
	var disc = load('res://scenes/Disc.tscn').instance()
	disc.position = screen_size * 0.5
	disc.init(props)
	add_child(disc)
	return disc


func remove_all_discs() -> void:
	var discs = get_children()
	for disc in discs:
		remove_child(disc)

func handle_disc_logic(delta):
	var discs = get_discs()
	var colliding_pairs = []
	
	# Update circle positions
	for d in discs:
		d.move(delta)
		
		# Bounce on screen edge
		if d.left() < 0:
			d.position.x = d.radius
			d.velocity.x = -d.velocity.x
		if d.right() > screen_size.x:
			d.position.x = screen_size.x - d.radius
			d.velocity.x = -d.velocity.x
		if d.top() < 0:
			d.position.y = d.radius
			d.velocity.y = -d.velocity.y
		if d.bottom() > screen_size.y:
			d.position.y = screen_size.y - d.radius
			d.velocity.y = -d.velocity.y
	
	for d1 in discs:
		for d2 in discs:
			if d1.name != d2.name:
				if d1.handle_collision(d2):
					colliding_pairs.push_back([d1, d2])
					# Displace balls away from collision
					var distance_vector = d1.position - d2.position
					var distance_between_circles = distance_vector.length()
					var overlap = 0.5 * (distance_between_circles - d1.radius - d2.radius)
					var displacement = overlap * distance_vector / distance_between_circles
					d1.position -= displacement
					d2.position += displacement
		
#		if c.in_play:
#			if c.position.y - c.radius < get_top_zone().end.y:
#				c.position.y = get_top_zone().end.y + c.radius
#				c.velocity.y = -c.velocity.y
#			if c.position.y + c.radius > get_bottom_zone().position.y:
#				c.position.y = get_bottom_zone().position.y - c.radius
#				c.velocity.y = -c.velocity.y
#		else:
#			if c.position.y - c.radius < 0:
#				c.position.y = c.radius
#				c.velocity.y = -c.velocity.y
#			if c.position.y + c.radius > screen_size.y:
#				c.position.y = screen_size.y - c.radius
#				c.velocity.y = -c.velocity.y
		
	# Dynamic Collision
	for pair in colliding_pairs:
		var d1 = pair[0]
		var d2 = pair[1]
		
		var distance = (d1.position - d2.position).length()
		var normal = (d2.position - d1.position) / distance
		
		# Wikipedia maths
		var k = d1.velocity - d2.velocity
		var p = 2.0 * (normal.x * k.x + normal.y * k.y) / (d1.mass + d2.mass)
#		if not c1.grabbed:
		d1.velocity -= Vector2(p,p) * d2.mass * normal
#		if not c2.grabbed:
		d2.velocity += Vector2(p,p) * d1.mass * normal
		
		
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
		
		
		