tool
extends Area2D

export(int) var height = 1

onready var animation_player = $AnimationPlayer
onready var mid = $Mid
onready var top = $Top

var mid_tiles = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func increment_height() -> void:
	var new_tile = mid.duplicate()
	mid_tiles.append(new_tile)
	new_tile.position.y = -16 * mid_tiles.size()
	top.position.y = -16 * mid_tiles.size()
	add_child(new_tile)
	var animation = animation_player.get_animation("erupt")
	
	var track_idx = animation.find_track(@"Mid:region_rect")
	
	animation.copy_track(track_idx, animation)
	
	var new_index = animation.get_track_count() - 1
	var new_path = new_tile.name + ":region_rect"
	print(new_path)
	animation.track_set_path(new_index, new_path)
	

func decrement_height() -> void:
	if mid_tiles.size() > 0:
		var animation = animation_player.get_animation("erupt")
		animation.remove_track(animation.get_track_count() - 1)
		var tile = mid_tiles.pop_back()
		tile.queue_free()
		top.position.y = -16 * mid_tiles.size()


func _on_Button_pressed() -> void:
	increment_height()


func _on_Decrement_pressed() -> void:
	decrement_height()
