extends Panel

var selected_item: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for str in Settings.check_resource_packs():
		$ZonesToSearch.add_item(str)


func _on_zones_to_search_item_selected(index: int) -> void:
	selected_item = $ZonesToSearch.get_item_text(index)
