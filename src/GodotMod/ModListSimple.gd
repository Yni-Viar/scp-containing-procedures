extends ItemList
## Made by Godot Mod Loader team, licensed under CC0

var _mods: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate():
	clear()
	var user_profile = ModLoaderUserProfile.get_current()
	
	for mod_id in user_profile.mod_list.keys():
		if ModLoaderStore.mod_data.has(mod_id):
			var mod: ModData = ModLoaderStore.mod_data[mod_id]

			# Check if the mod is loadable
			if mod.is_loadable:
				add_item(mod.dir_name)
				_mods.append(mod.dir_path)
	if item_count == 0:
		get_parent().get_parent().get_node("NoAssetsWarn").show()
	else:
		get_parent().get_parent().get_node("NoAssetsWarn").hide()


func _on_item_selected(index: int) -> void:
	get_tree().root.get_node("Main").package_path = _mods[index]
