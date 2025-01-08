extends BasePuppetScript
## SCP-266 puppet script
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License
class_name Scp266PlayerScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var heat_targets: Array[Node3D] = []
var active_targets: Array[int] = []
var timer: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scp_262_heateater(delta)

func scp_262_heateater(delta: float):
	if timer > 0:
		timer -= delta
	else:
		if heat_targets.size() > 0:
			for i in range(heat_targets.size()):
				if heat_targets[i] is NpcPlayerScript:
					# Only humans (and SCP-131) will freeze
					if heat_targets[i].puppet_class.fraction == 0:
						heat_targets[i].health_manage(-10)
				elif heat_targets[i] is InteractableHeater:
					if !heat_targets[i].enabled:
						active_targets.erase(i)
					else:
						active_targets.append(i)
			get_parent().set_movement_target(heat_targets[rng.randi_range(0, heat_targets.size() - 1)].global_position, false, false)
		timer = 4.0

func _on_warm_detector_body_entered(body: Node3D) -> void:
	if body is InteractableHeater:
		heat_targets.append(body)
	if body is NpcSelection:
		heat_targets.append(body.get_parent())


func _on_warm_detector_body_exited(body: Node3D) -> void:
	if body is InteractableHeater:
		heat_targets.erase(body)
	if body is NpcSelection:
		if heat_targets.has(body.get_parent()):
			heat_targets.erase(body.get_parent())
