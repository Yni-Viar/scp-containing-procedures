extends Node
class_name AppManager

## Called when the node enters the scene tree for the first time.
func _ready():
	Settings.touchscreen = DisplayServer.is_touchscreen_available()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

## Start the game!
func play(package_name: String, seed: String):
	$CanvasLayer/ColorRect.show()
	if !FileAccess.file_exists("res://ResourcePacks/" + package_name + "/"):
		if !Settings.load_resource_pack(package_name + ".pck"):
			alert("Pack not found in base dir. You need to download this pack from trusted source...")
	var game: GameCore = load("res://ResourcePacks/" + package_name + "/Scenes/Game.tscn").instantiate()
	game.game_data = load("res://ResourcePacks/" + package_name + "/gamedata.tres")
	game.seed = seed
	get_tree().root.add_child(game, true)
	self.queue_free()

func alert(message: String):
	var window: AcceptDialog = load("res://Assets/HUD/CustomAcceptDialog.tscn").instantiate()
	window.dialog_text = message
