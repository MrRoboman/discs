extends Node


func is_down(event):
	return event is InputEventScreenTouch and event.is_pressed()

func is_up(event):
	return event is InputEventScreenTouch and not event.is_pressed()

func is_up_index(event, tap_index):
	return is_up(event) and event.index == tap_index

func is_drag(event):
	return event is InputEventScreenDrag

func is_drag_index(event, tap_index):
	return is_drag(event) and event.index == tap_index
