extends Node3D
## New player script
class_name SpectatorPlayerScript

@onready var raycast = $Camera3D/RayCast3D
@onready var camera = $Camera3D
var speed: float = 0.75
var direction: Vector3
var selected_pawn: NpcPlayerScript

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Settings.setting_res.mouse_sensitivity * 0.05)
		camera.rotate_x(clamp(-event.relative.y * Settings.setting_res.mouse_sensitivity * 0.05, -90, 90))
		
		var camera_rot = $Camera3D.rotation_degrees
		camera_rot.x = clamp($Camera3D.rotation_degrees.x, -85, 85)
		$Camera3D.rotation_degrees = camera_rot

	direction = Vector3()
	direction.z = -Input.get_action_strength("move_forward") + Input.get_action_strength("move_backward")
	direction.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)

func _physics_process(delta: float) -> void:
	if !direction.is_zero_approx():
		global_position += direction * speed
