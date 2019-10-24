extends Node2D

onready var Tap = get_node('/root/Tap')
var tap_index:int = -1

const GAME_OBJECT_KEY = 'discs'

var firebase:Node
var data:Dictionary
var load_attempts_left:int = 10

var selected_disc


func current_game_name() -> String:
	return $UI/GameDropdown.get_current_game_name()
	
func get_discs() -> Array:
	return $Play.get_children()

func select_disc(disc:Disc) -> void:
	selected_disc = disc
	if disc:
		$UI/AttributesWindow.open(disc.get_data())
	else:
		$UI/AttributesWindow.close()
	update()

func move_selected_disc(position:Vector2) -> void:
	if selected_disc:
		selected_disc.position = position
		update()

func _draw():
	if selected_disc:
		draw_rect(selected_disc.get_rect(), Color(0,0,0), false)

func _ready():
	firebase = get_node('/root/Firebase')
	firebase.connect('request_completed', self, 'on_request_completed')
	firebase.load_data()


func init(_data:Dictionary) -> void:
	data = _data
	for game in data['games'].keys():
		$UI/GameDropdown.add_item(game)
	select_game(current_game_name())


func on_request_completed(response):
	if response:
		init(response)
		firebase.disconnect('request_completed', self, 'on_request_completed')
	elif load_attempts_left > 0:
		load_attempts_left -= 1
		firebase.load_data()
	else:
		print('Cannot connect to server')

func _input(event):
	if Tap.is_down(event) and event.index == 4:
		toggle_UI()
		
	if !$UI.visible:
		$Play.input(event)
		return
	
	if tap_index == -1 and Tap.is_down(event):
		if $UI/AttributesWindow.has_point(event.position):
			return
		
		for d in get_discs():
			if d.has_point(event.position):
				tap_index = event.index
				select_disc(d)
				return
		
		select_disc(null)
	
	if Tap.is_up_index(event, tap_index):
		tap_index = -1
		save_game()
	
	if Tap.is_drag_index(event, tap_index):
		move_selected_disc(event.position)
			
			
#	if event is InputEventScreenTouch:
#		if event.is_pressed():
#			print('Click Tool')
#			if event.index == 4 or event.position.distance_to(Vector2()) < 20:
#				$Debug/ControlPanel.btoggle()
#			if !$UI/AttributesWindow.overlaps(event.position):
#				select_disc(null)
#
#			var discs = get_discs()
#			for d in discs:
#				if d.point_overlaps(event.position):
#					select_disc(d)
				
			
#			ball.velocity = (bottom_disc.position - ball.position)
#		else: # Unpressed
#			select_disc(null)
#			save_game()

#	if event is InputEventScreenDrag:
#		if selected_disc:
#			move_selected_disc(event.position)


func toggle_UI() -> void:
	select_disc(null)
	$UI.visible = !$UI.visible


func create_game() -> void:
	var new_game_name = $UI/NewGameDialog/NewGameLineEdit.text
	$UI/NewGameDialog/NewGameLineEdit.text = ''
	$UI/NewGameDialog.hide()
	
	firebase.save_game(new_game_name, {GAME_OBJECT_KEY: 0}) # Check response.
	data['games'][new_game_name] = {GAME_OBJECT_KEY: 0}
	$UI/GameDropdown.add_game(new_game_name)
	select_game(new_game_name)

func save_game():
	var game_data = { GAME_OBJECT_KEY: [] }
	var discs = get_discs()
	for disc in discs:
		game_data[GAME_OBJECT_KEY].push_back(disc.get_data())
	data['games'][current_game_name()] = game_data
	firebase.save_game(current_game_name(), game_data)
#	print('firebase save is commented out')

func select_game(game_name:String) -> void:
	# logic to create remove circles
	$UI/GameDropdown.select_game(game_name)
	$Play.remove_all_discs()
	var disc_data = data['games'][game_name]['discs']
	for data in disc_data:
		var disc = $Play.add_disc(data)
		disc.connect("clicked", self, "on_click_disc")
	
	

func delete_game() -> void:
	firebase.delete_game(current_game_name()) # Check response and do the rest conditionally.
	data['games'].erase(current_game_name())
	$UI/GameDropdown.remove_current_game()
	select_game(current_game_name())


######## Event Listeners ##########

func _on_AddGameButton_pressed():
	$UI/NewGameDialog.popup()
	$UI/NewGameDialog/NewGameLineEdit.grab_focus()


func _on_NewGameOkButton_pressed():
	create_game()


func _on_NewGameLineEdit_text_entered(new_text):
	create_game()


func _on_DeleteGameButton_pressed():
	$UI/DeleteGameConfirm.show()


func _on_DeleteGameConfirm_confirmed():
	delete_game()


func _on_NewCircleButton_pressed():
	var disc = $Play.add_disc({'radius': 100})
	disc.connect("clicked", self, "on_click_disc")
	save_game()


func _on_SaveGameButton_pressed():
	save_game()


func _on_GameDropdown_item_selected(ID):
	select_game(current_game_name())



func _on_AttributesWindow_value_updated(args):
	var key = args[0]
	var value = args[1]
	selected_disc.set(key, value)
	update()

func on_click_disc(disc):
	print('click disc')
	select_disc(disc)


func _on_ToggleUiButton_pressed():
	toggle_UI()
