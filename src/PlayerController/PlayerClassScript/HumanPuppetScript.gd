extends BasePuppetScript
## Example implementation of human system.
## Made by Yni, licensed under MIT license.
class_name HumanPuppetScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
enum SecondaryState {NONE, ITEM, CUFFED}

@export var secondary_state: SecondaryState = SecondaryState.NONE

var raycast: RayCast3D
var vision_entity: Array = []

# Called when the node enters the scene tree for the first time.
func on_start():
	raycast = get_parent().get_node("RayCast3D")
	if get_node_or_null("AnimationTree") != null:
		get_node("AnimationTree").active = true
	#get_parent().get_node("NpcSelection").set_collision_mask_value(3, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_node_or_null("AnimationTree") != null:
		match state:
			States.IDLE:
				if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") - 0.00001 < -1:
					call("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), -1.0, get_parent().character_speed * delta))
			States.WALKING:
				if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") + 0.00001 > 0:
					call("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), 0.0, get_parent().character_speed * delta))
			States.RUNNING:
				if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") + 0.00001 > 1:
					call("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), 1.0, get_parent().character_speed * delta))
		match secondary_state:
			SecondaryState.NONE:
				if !get_node("AnimationTree").get("parameters/items_blend/blend_amount") - 0.00001 < 0:
					call("set_state", "items_blend", "blend_amount", lerp(get_node("AnimationTree").get("parameters/items_blend/blend_amount"), 0.0, get_parent().character_speed * delta))
			SecondaryState.ITEM:
				call("set_state", "secondary_state", "transition_request", "item")
			SecondaryState.CUFFED:
				call("set_state", "secondary_state", "transition_request", "cuffed")
		if secondary_state != SecondaryState.NONE:
			if !get_node("AnimationTree").get("parameters/items_blend/blend_amount") + 0.00001 > 1:
				call("set_state", "items_blend", "blend_amount", lerp(get_node("AnimationTree").get("parameters/items_blend/blend_amount"), 1.0, get_parent().character_speed * delta))
	
	if active_puppets.size() > 0 && state == States.IDLE:
		var looking_object: Vector3 = active_puppets[0].global_position
		looking_object.y = 0
		look_at(looking_object)
	on_update(delta)

func on_update(delta):
	pass

## Set animation to an entity via Animation Tree.
func set_state(animation_name: String, action_name: String, amount):
	get_node("AnimationTree").set("parameters/" + animation_name + "/" + action_name, amount)

func set_anim_state(animation_name: String):
	$AnimationPlayer.play(animation_name)

func footstep(key: String):
	get_parent().get_node("WalkSounds").stream = load(get_parent().puppet_class.footstep_sounds[key][rng.randi_range(0, get_parent().puppet_class.footstep_sounds[key].size() - 1)])
	get_parent().get_node("WalkSounds").play()
