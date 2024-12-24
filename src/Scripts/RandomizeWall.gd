extends Marker3D
class_name WallSpawner

enum Axis {X, Z}

@export var walls_to_spawn: Array[PackedScene] = []
@export_range(1, 4) var iterations: int = 4
@export var axis: Axis = Axis.Z
@export var offset: float = 5.12

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(iterations):
		var wall: Node3D = walls_to_spawn[rng.randi_range(0, walls_to_spawn.size() - 1)].instantiate()
		match axis:
			Axis.X:
				wall.position.x = offset * i
			Axis.Z:
				wall.position.z = offset * i
		add_child(wall)
		#pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
