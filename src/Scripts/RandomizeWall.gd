extends Marker3D

enum Axis {X, Z}

@export var walls_to_spawn: Array[PackedScene] = []
@export_range(1, 4) var iterations: int = 4
@export var axis: Axis = Axis.X

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var next_aabb_end: Vector3 = Vector3.ZERO
	for i in range(iterations):
		var wall: StaticBody3D = walls_to_spawn[rng.randi_range(0, walls_to_spawn.size() - 1)].instantiate()
		wall.position = next_aabb_end
		add_child(wall)
		match axis:
			Axis.X:
				next_aabb_end.x += wall.get_node("Mesh").mesh.get_aabb().size.x
			Axis.Z:
				next_aabb_end.z += wall.get_node("Mesh").mesh.get_aabb().size.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
