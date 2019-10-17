extends Node2D
class_name Play


onready var screen_size = get_viewport_rect().size


func add_disc(props:Dictionary = {}) -> Disc:
	var disc = load('res://scenes/Disc.tscn').instance()
	disc.position = screen_size * 0.5
	disc.init(props)
	add_child(disc)
	return disc


func remove_all_discs() -> void:
	var discs = get_children()
	for disc in discs:
		remove_child(disc)
