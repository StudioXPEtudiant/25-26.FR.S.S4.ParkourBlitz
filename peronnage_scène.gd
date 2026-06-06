extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $visuelle/Running/AnimationPlayer
const SPEED = 3
const JUMP_VELOCITY = 4.5
var sens_horizontal = 0.5
var sens_vertical = 0.5
const CAMERA_MIN_ANGLE = -40
const CAMERA_MAX_ANGLE = 20

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x,
			deg_to_rad(CAMERA_MIN_ANGLE),
			deg_to_rad(CAMERA_MAX_ANGLE)
		)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("q", "d", "s", "z")
	var input_dir = Input.get_vector("d", "q", "s", "z")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animation_player.play("mixamo_com")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
