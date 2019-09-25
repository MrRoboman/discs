extends Node2D

func _ready():
	pass

#func _physics_process(delta):

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
