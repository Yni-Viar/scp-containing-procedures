extends Node3D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var game_data: GameData
@export var current_ambient: String = "res://Sounds/Music/lcz_ambient.wav"

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackgroundMusic.stream = load(current_ambient)
	$BackgroundMusic.play()
	load_settings()
	$FacilityGenerator.prepare_generation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func quit():
	Settings.first_start = true
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func load_settings():
	$WorldEnvironment.environment.ssao_enabled = Settings.setting_res.ssao
	$WorldEnvironment.environment.ssil_enabled = Settings.setting_res.ssil
	$WorldEnvironment.environment.ssr_enabled = Settings.setting_res.ssr
	$WorldEnvironment.environment.glow_enabled = Settings.setting_res.glow
	if !Settings.setting_res.reflection_probes:
		for node in get_tree().get_nodes_in_group("ReflectionProbes"):
			if node is ReflectionProbe:
				node.hide()
	if !Settings.setting_res.dynamic_gi:
		for node in get_tree().get_nodes_in_group("VoxelGI"):
			if node is VoxelGI:
				node.hide()


func _on_facility_generator_generated() -> void:
	if get_node_or_null("FacilityGenerator/lc_cont1_testroom/playerspawn") != null:
		$Spectator.global_position = get_node("FacilityGenerator/lc_cont1_testroom/playerspawn").global_position
	startup_spawn()


func startup_spawn():
	for puppet_res in game_data.puppet_classes:
		var spawn_point_group = get_tree().get_nodes_in_group(puppet_res.spawn_point_group)
		var used_spawns: Array[int] = []
		for i in range(spawn_point_group.size()):
			if i > puppet_res.initial_amount:
				break
			var random_number: int = rng.randi_range(0, spawn_point_group.size() - 1)
			if used_spawns.has(random_number):
				continue
			$NPCs.object_spawner(puppet_res, spawn_point_group[random_number].global_position)
			used_spawns.append(random_number)
