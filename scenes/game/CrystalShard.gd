tool
extends Area2D


onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.interpolate_property($crystal_shard, "scale", Vector2(1, 1), Vector2(0, 1), 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property($crystal_shard, "scale", Vector2(0, 1), Vector2(1, 1), 1, Tween.TRANS_QUAD, Tween.EASE_OUT, 1)
	tween.start()



func _on_CrystalShard_body_entered(body: Node) -> void:
	SaveGame.collected_shards += 1
	# TODO collection sound
	queue_free()
