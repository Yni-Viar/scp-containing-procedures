extends Control
## Main menu script
## Created by Yni, licensed under MIT License

var play_info_toggle: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	match Settings.CURRENT_STAGE:
		Settings.Stages.release:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackground.png")
		Settings.Stages.testing:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundTesting.png")
		_:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundIndev.png")
	
	if OS.get_name() != "Android":
		get_window().size = Settings.window_size[Settings.setting_res.ui_window_size]
	else:
		$Title/Exit.hide()
		if OS.is_debug_build():
			OS.request_permissions()
	
	AudioServer.set_bus_volume_db(0, linear_to_db(Settings.setting_res.sound))
	if Settings.setting_res.sound < 0.01:
		AudioServer.set_bus_mute(0, true)
	elif Settings.setting_res.sound >= 0.01 && AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	
	AudioServer.set_bus_volume_db(1, linear_to_db(Settings.setting_res.music))
	if Settings.setting_res.sound < 0.01:
		AudioServer.set_bus_mute(1, true)
	elif Settings.setting_res.sound >= 0.01 && AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
	
	
	TranslationServer.set_locale(Settings.setting_res.available_languages[Settings.setting_res.ui_language])
	Settings.first_start = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_play_pressed():
	get_parent().get_parent().play($Panel/Seed.text)


func _on_settings_pressed():
	$Settings.show()


func _on_credits_pressed():
	$CreditsPanel.show()


func _on_exit_pressed():
	get_tree().quit()


func _on_credits_back_pressed():
	$CreditsPanel.hide()
