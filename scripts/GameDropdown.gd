extends OptionButton


func get_current_game_name() -> String:
	return get_item_text(selected)


func add_game(game_name:String) -> void:
	add_item(game_name)


func select_game(game_name:String) -> void:
	var idx = get_item_count() - 1
	while idx >= 0:
		if get_item_text(idx) == game_name:
			select(idx)
			return
		idx -= 1


func remove_current_game() -> void:
	var old_selected = selected
	var next_selected = (selected + 1) % get_item_count()
	# BUG: Calling remove_item(selected) does not update current selected item.
	# So select the next item, remove current item, then return selection to the original selected index.
	select(next_selected)
	remove_item(old_selected)
	select(old_selected)
