extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().get_node("Puppet") is Scp049PlayerScript:
			var scp049: Scp049PlayerScript = body.get_parent().get_node("Puppet")
			scp049.cured.connect(on_cured)

func _on_body_exited(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().get_node("Puppet") is Scp049PlayerScript:
			var scp049: Scp049PlayerScript = body.get_parent().get_node("Puppet")
			scp049.cured.disconnect(on_cured)

func on_cured(puppet_team: int):
	if puppet_team != 1:
		get_tree().root.get_node("Game/FoundationTask").do_task("S19_TEST_049_CURE")
