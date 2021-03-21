extends "res://util/PersistentProperties.gd"


var red_orb_collected: bool = false
var green_orb_collected: bool = false
var blue_orb_collected: bool = false

var orb_equipped: int = -1


var collected_shards: int = 0
var tutorial_completed: bool = false
var orbs_disappeared: bool = false
var shards_disappeared: bool = false
var game_completed: bool = false


func _init():
	# override filename
	filepath = 'user://save_game.json'
