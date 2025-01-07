extends Node

enum SpecialEvent {NONE, POSITIVE, NEGATIVE}

signal task_done

var tasks_left: int = 1
var all_tasks: Array[FoundationTaskResource]
var special_event: SpecialEvent = SpecialEvent.NONE
var scps_outside_container: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var used_index: Array[int] = []
	for i in range(tasks_left):
		if get_parent().game_data.tasks.size() - 1 < i:
			break
		var task_index: int
		while true:
			task_index = get_parent().rng.randi_range(0, get_parent().game_data.tasks.size() - 1)
			if !used_index.has(task_index):
				break
		used_index.append(task_index)
		all_tasks.append(get_parent().game_data.tasks[task_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func do_task(task_name: String):
	for task in all_tasks:
		if task.internal_name == task_name:
			all_tasks.erase(task)
			task_done.emit()
			break

func trigger_event(res: FoundationTaskResource, event_type: SpecialEvent):
	all_tasks.clear()
	special_event = event_type
	all_tasks.append(res)
	task_done.emit()

func secure_contain_protect(contained: bool, scp_name: String):
	if contained:
		get_tree().root.get_node("Game/FoundationTask").scps_outside_container.erase(scp_name)
	else:
		get_tree().root.get_node("Game/FoundationTask").scps_outside_container.append(scp_name)
	if scps_outside_container.size() >= 2:
		get_parent().finish_game(2, "You let the SCPs escape. You will become Class-D Personnel next week.")
	elif scps_outside_container.size() > 0:
		trigger_event(load("res://Assets/Tasks/ContainmentBreach.tres"), 2)
	else:
		do_task("EVENT_CB")

func has_task(task_name: String) -> bool:
	for task in all_tasks:
		if task.internal_name == task_name:
			return true
	return false
