extends Node3D
## Used from Godot docs tutorial
## Created by Godot Engine contributors, licensed under MIT License
class_name NpcPlayerScript

@export var puppet_class: PuppetClass
@export var character_speed := 10.0
@export var automatic: bool = false
## See PuppetResource description
@export var fraction: int
@export var health: float
@export var current_health: float

var puppet_mesh: BasePuppetScript

@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
var movement_delta: float

func _ready() -> void:
	$RayCast3D.add_exception($NpcSelection)
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	puppet_mesh = puppet_class.prefab.instantiate()
	automatic = puppet_class.automatic
	fraction = puppet_class.fraction
	health = puppet_class.health
	current_health = health
	add_child(puppet_mesh)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	puppet_mesh.state = puppet_mesh.States.WALKING
	if puppet_class.apply_height_bugfix:
		puppet_mesh.position.y = -0.4
	set_physics_process(true)

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		puppet_mesh.state = puppet_mesh.States.IDLE
		set_physics_process(false)
		return
	if navigation_agent.is_navigation_finished():
		puppet_mesh.state = puppet_mesh.States.IDLE
		set_physics_process(false)
		return

	movement_delta = character_speed * delta
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_delta
	var offset: Vector3 = next_path_position - global_position
	offset.y = 0
	look_at(global_position + offset, Vector3.UP)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
## Health management
func health_manage(health_to_add: float):
	if current_health + health_to_add <= health:
		current_health += health_to_add
	else:
		current_health = health
	
	if current_health <= 0:
		get_tree().root.get_node("Game/NPCs").object_remover(name)
