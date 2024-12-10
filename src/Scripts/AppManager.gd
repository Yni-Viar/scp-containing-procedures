extends Node
## Main script, currently useful only for Main Menu back-end
## Created by Yni, licensed under MIT License
class_name AppManager

## Called when the node enters the scene tree for the first time.
func _ready():
	Settings.touchscreen = DisplayServer.is_touchscreen_available()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

## Loads the game from package
func play(package_name: String, seed: String):
	if package_name.is_empty() || package_name == null:
		alert("Select resource pack to play. E.g. \"Site19\"")
		return
	$CanvasLayer/ColorRect.show()
	var dir = DirAccess.open("res://ResourcePacks/" + package_name + "/")
	if !dir:
		# Load the game, if the package is missing
		if !Settings.load_resource_pack(package_name + ".pck"):
			alert("Pack not found in base dir. You need to download this pack from trusted source...")
			$CanvasLayer/ColorRect.hide()
			return
	var game: GameCore = load("res://ResourcePacks/" + package_name + "/Scenes/Game.tscn").instantiate()
	game.seed = seed
	get_tree().root.add_child(game, true)
	self.queue_free()

## Create alert window and show the message to user
func alert(message: String):
	var window: AcceptDialog = load("res://Assets/HUD/CustomAcceptDialog.tscn").instantiate()
	window.dialog_text = message
	add_child(window)
