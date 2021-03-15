extends Node


# counter for switching between players
var count = 0

# array containing the music players
var players: Array

# these are needed to interpolate the propertier in the right direction
var active_player: AudioStreamPlayer
var idle_player: AudioStreamPlayer

# Tween for interpolating the volumes
var tween: Tween




# all available songs
const songs = {
	"Awakening": {
		"stream": preload("res://audio/songs/ZitronSound - Awakening.ogg"),
		"volume": 0
	},
	"Crystals": {
		"stream": preload("res://audio/songs/ZitronSound - Crystals.ogg"),
		"volume": 0
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	# two players are needed for blending between songs
	for i in range(2):
		var player = AudioStreamPlayer.new()
		player.bus = "Music"
		players.append(player)
		add_child(player)
	
	tween = Tween.new()
	add_child(tween)


# Play next song, fade volumes between songs
func play_song(song_name: String, transition: float = 3.0):
	tween.stop_all()
	print("Switching to song %s" % song_name)
	
	# determine currently running player
	active_player = players[count % 2]
	idle_player = players[1 - count % 2]
	count += 1
	
	var song = songs[song_name]
	idle_player.stream = song["stream"]
	idle_player.volume_db = linear2db(0) # begin with 0 and fade to volume
	idle_player.play()
	
	tween.interpolate_method(self, "set_active_player_volume", db2linear(active_player.volume_db), 0, transition)
	tween.interpolate_method(self, "set_idle_player_volume", db2linear(idle_player.volume_db), db2linear(song["volume"]), transition)
	
	tween.interpolate_callback(active_player, transition, "stop")
	tween.start()


func set_active_player_volume(new_volume: float):
	active_player.volume_db = linear2db(new_volume)


func set_idle_player_volume(new_volume: float):
	idle_player.volume_db = linear2db(new_volume)
