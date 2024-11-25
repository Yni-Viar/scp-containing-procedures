extends BasePuppetScript
## Example implementation of human system.
## Made by Yni, licensed under MIT license.
class_name HumanPuppetScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
enum SecondaryState {NONE, ITEM}

@export var secondary_state: SecondaryState = SecondaryState.NONE

var raycast: RayCast3D
var vision_entity: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	raycast = get_parent().get_node("RayCast3D")
	if get_node_or_null("AnimationTree") != null:
		get_node("AnimationTree").active = true
	#get_parent().get_node("NpcSelection").set_collision_mask_value(3, true)
	on_start()

func on_start():
	pass

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
					call("set_state", "items_blend", "blend_amount", 0)
			SecondaryState.ITEM:
				if !get_node("AnimationTree").get("parameters/items_blend/blend_amount") + 0.00001 > 1:
					call("set_state", "items_blend", "blend_amount", 1)
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is NpcSelection:
			var selected_pawn = collider.get_pawn()
			if selected_pawn != null:
				var puppet_class = selected_pawn.puppet_class
				if puppet_class.fraction == 2:
					vision_entity.append(selected_pawn.get_node("Puppet"))
					if !selected_pawn.get_node("Puppet").watching_puppets.has(get_parent()):
						selected_pawn.get_node("Puppet").watching_puppets.append(get_parent())
				elif vision_entity.size() > 0:
					for entity in vision_entity:
						entity.watching_puppets.clear()
					vision_entity.clear()
		elif vision_entity.size() > 0:
			for entity in vision_entity:
				entity.watching_puppets.clear()
			vision_entity.clear()
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
