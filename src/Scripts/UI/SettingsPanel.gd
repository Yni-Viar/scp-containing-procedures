extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	#var ini: IniParser = IniParser.new()
	#var result: Array = ini.load_ini("user://settings.ini", "Settings", Settings.available_settings)
	for v in Settings.window_size:
		$ScrollContainer/HBoxContainer/Page1/WindowSizeSet.add_item(str(v.x) + "x" + str(v.y))
	
	$ScrollContainer/HBoxContainer/Page1/VoxelGISet.button_pressed = Settings.setting_res.dynamic_gi
	$ScrollContainer/HBoxContainer/Page1/SSAOSet.button_pressed = Settings.setting_res.ssao
	$ScrollContainer/HBoxContainer/Page1/SSILSet.button_pressed = Settings.setting_res.ssil
	$ScrollContainer/HBoxContainer/Page1/SSRSet.button_pressed = Settings.setting_res.ssr
	$ScrollContainer/HBoxContainer/Page1/FogSet.button_pressed = Settings.setting_res.fog
	$ScrollContainer/HBoxContainer/Page2/MusicSet.value = Settings.setting_res.music
	$ScrollContainer/HBoxContainer/Page2/SoundSet.value = Settings.setting_res.sound
	if OS.get_name() != "Android":
		$ScrollContainer/HBoxContainer/Page1/WindowSizeSet.selected = Settings.setting_res.ui_window_size
		$ScrollContainer/HBoxContainer/Page1/FullscreenSet.button_pressed = Settings.setting_res.fullscreen
	$ScrollContainer/HBoxContainer/Page2/MouseSensSet.value = Settings.setting_res.mouse_sensitivity
	# 9 is Window Size in pixels
	$ScrollContainer/HBoxContainer/Page1/LanguageSet.selected = Settings.setting_res.ui_language
	$ScrollContainer/HBoxContainer/Page1/GlowSet.button_pressed = Settings.setting_res.glow
	$ScrollContainer/HBoxContainer/Page1/PuppetWanderingSet.button_pressed = Settings.setting_res.enable_wandering
	
	$ScrollContainer/HBoxContainer/Page1/Lights.button_pressed = Settings.setting_res.enable_lighting
	device_check()

func _on_language_set_item_selected(index):
	TranslationServer.set_locale(Settings.setting_res.available_languages[index])
	Settings.setting_res.language = Settings.setting_res.available_languages[index]


func _on_window_size_set_item_selected(index):
	Settings.setting_res.ui_window_size = index
	get_window().size = Settings.window_size[Settings.setting_res.ui_window_size]
	#Settings.save_setting("window_size", Settings.window_size)


func _on_fullscreen_set_toggled(toggled_on):
	if toggled_on:
		if !Settings.first_start:
			# Override Godot bug.
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Settings.setting_res.fullscreen = true
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		Settings.setting_res.fullscreen = false
	#Settings.save_setting("fullscreen", Settings.fullscreen)


func _on_ssao_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.ssao = true
	else:
		Settings.setting_res.ssao = false
	


func _on_ssil_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.ssil = true
	else:
		Settings.setting_res.ssil = false
	#Settings.save_setting("ssil", Settings.ssil)


func _on_ssr_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.ssr = true
	else:
		Settings.setting_res.ssr = false
	#Settings.save_setting("Ssr", Settings.ssr)


func _on_music_set_drag_ended(value_changed):
	if value_changed:
		Settings.setting_res.music = $ScrollContainer/HBoxContainer/Page2/MusicSet.value
		audio_Settings(1, Settings.setting_res.music)
		#Settings.save_setting("music", Settings.music)


func _on_sound_set_drag_ended(value_changed):
	if value_changed:
		Settings.setting_res.sound = $ScrollContainer/HBoxContainer/Page2/SoundSet.value
		audio_Settings(0, Settings.setting_res.sound)
		#Settings.save_setting("sound", Settings.sound)
		$SoundTest.play()


func _on_mouse_sens_set_drag_ended(value_changed):
	if value_changed:
		Settings.setting_res.mouse_sensitivity = $ScrollContainer/HBoxContainer/Page2/MouseSensSet.value
		#Settings.save_setting("mouse_sensitivity", Settings.mouse_sensitivity)

## Sets the audio bus
func audio_Settings(bus: int, val: float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(val))
	if val < 0.01:
		AudioServer.set_bus_mute(bus, true)
	elif val >= 0.01 && AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, false)


func _on_back_pressed():
	Settings.save_resource(Settings.setting_res)
	get_parent().hide()


func _on_glow_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.glow = true
	else:
		Settings.setting_res.glow = false
	#Settings.save_setting("glow", Settings.fullscreen)

func device_check():
	if OS.get_name() == "Android":
		$ScrollContainer/HBoxContainer/Page1/ResolutionLabel.hide()
		$ScrollContainer/HBoxContainer/Page1/WindowSizeSet.hide()
		$ScrollContainer/HBoxContainer/Page1/OverrideResolution.hide()
		$FileDialog.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	if OS.is_debug_build() && !OS.has_feature("editor") && OS.get_name() != "Web" && get_parent().get_parent().name == "MainMenu":
		$ScrollContainer/HBoxContainer/Page2/AssetsLabel.show()
		$ScrollContainer/HBoxContainer/Page2/LoadAsset.show()
	if RenderingServer.get_rendering_device() != null:
		$ScrollContainer/HBoxContainer/Page1/VoxelGISet.disabled = false
		$ScrollContainer/HBoxContainer/Page1/SSAOSet.disabled = false
		$ScrollContainer/HBoxContainer/Page1/SSILSet.disabled = false
		$ScrollContainer/HBoxContainer/Page1/SSRSet.disabled = false
		$ScrollContainer/HBoxContainer/Page1/FogSet.disabled = false
		$ScrollContainer/HBoxContainer/Page1/FogSet.show()
		$ScrollContainer/HBoxContainer/Page1/VoxelGISet.show()
		$ScrollContainer/HBoxContainer/Page1/SSAOSet.show()
		$ScrollContainer/HBoxContainer/Page1/SSILSet.show()
		$ScrollContainer/HBoxContainer/Page1/SSRSet.show()
		$ScrollContainer/HBoxContainer/Page1/VSyncSet.show()
	else: #ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		$ScrollContainer/HBoxContainer/Page1/VoxelGISet.button_pressed = false
		$ScrollContainer/HBoxContainer/Page1/SSAOSet.button_pressed = false
		$ScrollContainer/HBoxContainer/Page1/SSILSet.button_pressed = false
		$ScrollContainer/HBoxContainer/Page1/SSRSet.button_pressed = false
		$ScrollContainer/HBoxContainer/Page1/VoxelGISet.disabled = true
		$ScrollContainer/HBoxContainer/Page1/SSAOSet.disabled = true
		$ScrollContainer/HBoxContainer/Page1/SSILSet.disabled = true
		$ScrollContainer/HBoxContainer/Page1/SSRSet.disabled = true
		$ScrollContainer/HBoxContainer/Page1/VSyncSet.button_pressed = true
		$ScrollContainer/HBoxContainer/Page1/VoxelGISet.hide()
		$ScrollContainer/HBoxContainer/Page1/SSAOSet.hide()
		$ScrollContainer/HBoxContainer/Page1/SSILSet.hide()
		$ScrollContainer/HBoxContainer/Page1/SSRSet.hide()
		$ScrollContainer/HBoxContainer/Page1/VSyncSet.hide()
		$ScrollContainer/HBoxContainer/Page1/FogSet.button_pressed = false
		$ScrollContainer/HBoxContainer/Page1/FogSet.disabled = true
		$ScrollContainer/HBoxContainer/Page1/FogSet.hide()


func _on_fog_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.fog = true
	else:
		Settings.setting_res.fog = false
	#Settings.save_setting("fog", Settings.fog)


func _on_voxel_gi_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.voxel_gi = true
	else:
		Settings.setting_res.voxel_gi = false
	#Settings.save_setting("voxel_gi", Settings.voxel_gi)


func _on_v_sync_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.vsync = true
	else:
		Settings.setting_res.vsync = false


func _on_reflection_probes_set_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.reflection_probes = true
	else:
		Settings.setting_res.reflection_probes = false


func _on_light_shadows_toggled(toggled_on):
	if toggled_on:
		Settings.setting_res.enable_light_shadows = true
	else:
		Settings.setting_res.enable_light_shadows = false


func _on_override_resolution_pressed() -> void:
	var resolution_settings_window = load("res://Assets/SettingsUI/Resolution.tscn").instantiate()
	add_child(resolution_settings_window)

func add_new_resolution(x: String, y: String):
	$ScrollContainer/HBoxContainer/Page1/WindowSizeSet.add_item(x + "x" + y)

func _on_lights_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.setting_res.enable_lighting = true
	else:
		Settings.setting_res.enable_lighting = false


func _on_puppet_wandering_set_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.setting_res.enable_wandering = true
	else:
		Settings.setting_res.enable_wandering = false


func _on_load_asset_pressed() -> void:
	$FileDialog.show()
	


func _on_file_dialog_file_selected(path: String) -> void:
	if path.containsn(".zip"):
		var d: DirAccess = DirAccess.open(ModLoaderSetupUtils.get_local_folder_dir())
		d.copy(path, ModLoaderSetupUtils.get_local_folder_dir() + "/" + path.get_file())
		get_tree().root.get_node("Main").alert("You need to restart the game to see the effects")
		if OS.get_name() != "Android" || OS.get_name() != "Web":
			OS.set_restart_on_exit(true)
	else:
		get_tree().root.get_node("Main").alert("error")
