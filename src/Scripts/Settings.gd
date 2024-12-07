extends Node

enum Stages {release, testing, dev}
enum ItemType {item, map_object, npc}

signal settings_saved

## Migrated from Globals.
## Game's data compatibility for modding.
const DATA_COMPATIBILITY: String = "0.0.1"
## Migrated from Globals.
## Game's data compatibility for modding.
const CURRENT_STAGE: Stages = Stages.release
## Available languages
var available_languages: Array[String] = ["en", "ru"]
## Necessary for overriding Godot bug.
## Checks when settings would be loaded.
var first_start: bool = true
## Settings resource
var setting_res: SettingsResource
## Default windows sizes.
var window_size: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768),
						Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(800, 600)]

var touchscreen: bool = false

func _init():
	load_resource()
	# Add custom windows sizes.
	for v in setting_res.window_size:
		window_size.append(v)

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and loads settings
func load_resource():
	var settings_from_file = ResourceStorage.load_resource("user://Settings.bin", "SettingsResource")
	if settings_from_file != null:
		setting_res = settings_from_file
	else:
		if OS.get_name() == "Android":
			var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Mobile.tres")
			save_resource(res)
			setting_res = res
		elif RenderingServer.get_rendering_device() != null:
			var res = load("res://Scripts/SettingsResource/Presets/RD/Medium.tres")
			save_resource(res)
			setting_res = res
		else:
			var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Low.tres")
			save_resource(res)
			setting_res = res
## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and saves settings
func save_resource(res):
	ResourceStorage.save_resource("user://Settings.bin", res)
	emit_signal("settings_saved")

func get_current_dir() -> String:
	var current_dir: String = ""
	if OS.get_name() == "Android":
		if OS.is_debug_build():
			var dir: DirAccess
			current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/.SCP_AssetPack/"
			if !dir.dir_exists(current_dir):
				dir.make_dir(current_dir)
		else:
			current_dir = OS.get_user_data_dir()
	else:
		current_dir = OS.get_executable_path().get_base_dir()
	return current_dir

func load_resource_pack(resource_name: String) -> bool:
	
	if ProjectSettings.load_resource_pack(get_current_dir() + "/" + resource_name, false):
		return true
	else:
		return false

func check_resource_packs() -> Array[String]:
	var packs: Array[String] = []
	var dir = DirAccess.open(get_current_dir())
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				continue
			elif file_name.ends_with(".pck") && file_name != "SCPContainingProcedures.pck":
				packs.append(file_name.rstrip(".pck"))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return packs
