extends ItemPickable

var cuffed_players: Array[NpcPlayerScript] = []
var prev_position: Vector3

func _ready() -> void:
	prev_position = global_position

func _physics_process(delta: float) -> void:
	if prev_position != global_position:
		prev_position = global_position
		target_follow()

func use(player: Node3D, target_player: Node3D) -> void:
	if target_player == player:
		get_tree().root.get_node("Game").alert("""Can't disarm yourself.
		Perhaps you clicked the Use Item button from the inventory.
		You should click R key, or touch "Item" button to disarm someone""")
	elif target_player is NpcPlayerScript && player is NpcPlayerScript:
		var inv: Inventory = target_player.get_node("Inventory")
		for i in range(inv.inventory_storage.size()):
			inv.remove_item(i, true)
		var human_mesh: BasePuppetScript = target_player.get_node("Puppet")
		if human_mesh is HumanPuppetScript:
			if human_mesh.secondary_state == human_mesh.SecondaryState.CUFFED:
				human_mesh.secondary_state = human_mesh.SecondaryState.NONE
				cuffed_players.erase(target_player)
			elif player.puppet_class.team != target_player.puppet_class.team && cuffed_players.size() < 4:
				human_mesh.secondary_state = human_mesh.SecondaryState.CUFFED
				cuffed_players.append(target_player)
			else:
				get_tree().root.get_node("Game").alert("""Can't disarm a player.
				Perhaps you reached the limit of 4 cuffed players.""")

func target_follow():
	await get_tree().create_timer(2.5).timeout
	for player in cuffed_players:
		player.set_movement_target(global_position)