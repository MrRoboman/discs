extends 'res://scripts/CircleCollider.gd'

var last_position
var touch_index
var grabbed_offset

func _draw():
	if $CollisionShape2D.disabled:
		draw_circle(Vector2(), $CollisionShape2D.shape.get('radius'), Color(1,0,0,.5))
	else:
		draw_circle(Vector2(), $CollisionShape2D.shape.get('radius'), Color(1,0,0))


func get_radius():
	return $CollisionShape2D.shape.get('radius')


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed() and not touch_index:
#			print('press')
#			print(event.index)
			if position.distance_to(event.position) <= get_radius():
				touch_index = event.index
				grabbed_offset = event.position
				velocity = Vector2()
				$CollisionShape2D.disabled = true
				update()
		elif event.index == touch_index:
#			print('release')
#			print(event.index)
			touch_index = null
			grabbed_offset = null
			velocity = (position - last_position) * 20
			$CollisionShape2D.disabled = false
			update()
			
	if event is InputEventScreenDrag and event.index == touch_index:
#		print('drag')
#		print(event.index)
		grabbed_offset = event.position

func _physics_process(delta):
	last_position = position
	if grabbed_offset:
		position = grabbed_offset
	else:
		_handle_movement(delta)
	
	# handle screen escape
	var screen_size = get_viewport_rect().size
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		position = screen_size * .5
		velocity = Vector2()

