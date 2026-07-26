extends Node3D

signal mob_spawned(mob)

@export var mob_to_spawn: PackedScene = null

@onready var spawn_marker: Marker3D = %SpawnMarker
@onready var spawn_timer: Timer = %SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var new_mob = mob_to_spawn.instantiate()
	get_tree().current_scene.add_child(new_mob)
	new_mob.global_position = spawn_marker.global_position

	mob_spawned.emit(new_mob)
