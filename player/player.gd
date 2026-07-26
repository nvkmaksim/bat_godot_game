extends CharacterBody3D

const BULLET_3D = preload("uid://cwhs13vg0i751")

@onready var shoot_sound: AudioStreamPlayer = %ShootSound

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.3
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.3
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x, -60, +60
			)
	elif event.is_action_pressed("open_close_ui"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
	if Input.is_action_just_pressed("shoot") and %ShootTimer.is_stopped():
		shoot_bullet()

func _physics_process(delta: float) -> void:
	const SPEED = 5.5
	
	var input_direction_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
		)
	
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	velocity.y -= 20.0 * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = 7.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	move_and_slide()
	
func shoot_bullet():
	var new_bullet = BULLET_3D.instantiate()
	%BulletMarker.add_child(new_bullet)
	new_bullet.global_transform = %BulletMarker.global_transform
	%ShootTimer.start()
	shoot_sound.play()
