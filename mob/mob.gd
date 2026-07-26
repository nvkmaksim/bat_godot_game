extends RigidBody3D

signal died

signal clear

@onready var bat_model: Node3D = %bat_model

@onready var death_timer: Timer = %DeathTimer

@onready var player: CharacterBody3D = $"../Player"

@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

@onready var get_hit_sound: AudioStreamPlayer3D = %GetHitSound

@onready var death_sound: AudioStreamPlayer3D = %DeathSound

var health = 3.0
var speed = 4.0
var upward_force = Vector3.UP * 5.0

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI

func take_damage():
	if health == 0:
		return
	
	bat_model.hurt()
	health -= 1
	
	if health == 0:
		death_sound.play()
		set_physics_process(false)
		collision_shape_3d.set_deferred("disabled", true)
		gravity_scale = 1.0
		var direction = global_position.direction_to(player.global_position) * -1.0
		apply_central_impulse(direction * 10 + upward_force)
		died.emit()
		death_timer.start()
	else:
		get_hit_sound.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_death_timer_timeout() -> void:
	clear.emit()
	queue_free()
