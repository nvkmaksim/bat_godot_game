extends Node3D

const SMOKE_PUFF = preload("uid://cjk3frr43yesb")

@onready var label: Label = %Label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increase_score() -> void:
	score += 1
	label.text = "Score: " + str(score)

func do_poof(position) -> void:
	var new_poof = SMOKE_PUFF.instantiate()
	get_tree().current_scene.add_child(new_poof)
	new_poof.global_position = position

func _on_mob_spawner_mob_spawned(mob: Variant) -> void:
	do_poof(mob.position)
	mob.died.connect(increase_score)
	mob.clear.connect(func on_clear():
		do_poof(mob.position))

func _on_kill_plate_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
