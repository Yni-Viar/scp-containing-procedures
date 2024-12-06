extends ItemPickable


func use(player: Node3D, target_player: Node3D) -> void:
	if target_player == player:
		var window: AcceptDialog = load("res://Assets/HUD/CustomAcceptDialog.tscn").instantiate()
		window.dialog_text = """Can't disarm yourself.
		Perhaps you clicked the Use Item button from the inventory.
		You should click R key, or touch "Item" button to disarm someone"""
	elif target_player != null:
		var inv: Inventory = target_player.get_node("Inventory")
		for i in range(inv.inventory_storage.size()):
			inv.remove_item(i, true)
		var human_mesh: BasePuppetScript = target_player.get_node("Puppet")
		if human_mesh is HumanPuppetScript:
			if human_mesh.secondary_state == human_mesh.SecondaryState.CUFFED:
				human_mesh.secondary_state = human_mesh.SecondaryState.NONE
			else:
				human_mesh.secondary_state = human_mesh.SecondaryState.CUFFED
