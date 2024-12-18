#Copyright © 2022 Marc Nahr: https://github.com/MarcPhi/godot-free-look-camera
extends Camera3D
class_name FreeLookCamera

@export_range(0, 1000, 0.1) var default_velocity : float = 5
@export_range(0, 10, 0.01) var speed_scale : float = 1.17
@export_range(1, 100, 0.1) var boost_speed_multiplier : float = 3.0
@export var max_speed : float = 1000
@export var min_speed : float = 0.2

# Begin Yni's code
@onready var _velocity = default_velocity
@onready var raycast = $RayCast3D
var selected_pawn: NpcPlayerScript
## Workaround for touch screen
var interact_busy: bool = false
# End Yni's code

func _input(event):
	if not current:
		return
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && !Settings.touchscreen:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * Settings.setting_res.mouse_sensitivity * 0.05
			rotation.x -= event.relative.y * Settings.setting_res.mouse_sensitivity * 0.05
			rotation.x = clamp(rotation.x, PI/-2, PI/2)
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
				_velocity = clamp(_velocity * speed_scale, min_speed, max_speed)
			MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
				_velocity = clamp(_velocity / speed_scale, min_speed, max_speed)

func _physics_process(delta: float) -> void:
	if not current:
		return
		
	var direction = Vector3(
		float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")),
		float(Input.is_action_pressed("move_up")) - float(Input.is_action_pressed("move_down")), 
		float(Input.is_action_pressed("move_backward")) - float(Input.is_action_pressed("move_forward"))
	).normalized()
	
	if Input.is_action_pressed("move_sprint"): # boost
		translate(direction * _velocity * delta * boost_speed_multiplier)
	else:
		translate(direction * _velocity * delta)
	
	# THE CODE PART BELOW is made by Yni
	if !interact_busy:
		if Input.is_action_pressed("interact") && raycast.is_colliding():
			interact("Point")
		if Input.is_action_pressed("interact_alt") && raycast.is_colliding():
			interact("Item")
	if Input.is_action_just_released("interact") || Input.is_action_just_released("interact_alt"):
		interact_busy = false

func interact(value: String) -> void:
	interact_busy = true
	match value:
		"Point":
			var collider = raycast.get_collider()
			if collider is NpcSelection:
				selected_pawn = collider.get_pawn()
			elif collider is InteractableNode:
				collider.call("interact", self)
			elif selected_pawn != null:
				if selected_pawn is NpcPlayerScript:
					if !selected_pawn.automatic:
						selected_pawn.set_movement_target(raycast.get_collision_point(), true)
						if collider is ItemPickable:
							collider.call("interact", selected_pawn)
		"Item":
			var puppet: BasePuppetScript = selected_pawn.get_node("Puppet")
			var item: ItemPickable
			if puppet.get_node_or_null(puppet.armature_name + "/Skeleton3D/ItemAttachment/Marker3D") != null:
				var puppet_hand: Marker3D = puppet.get_node(puppet.armature_name + "/Skeleton3D/ItemAttachment/Marker3D")
				if puppet_hand.get_children().size() > 0:
					item = puppet_hand.get_child(0)
					var collider = raycast.get_collider()
					if collider is NpcSelection:
						item.call("use", selected_pawn, collider.get_parent())
