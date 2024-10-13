extends Node


@export var grid_manager: GridManager

## Building cursor. Visible on building mode
@onready var cursor: Sprite2D = $Cursor
## Turn on/off building mode
@onready var place_building_button: Button = $PlaceBuildingButton

var building_scene: PackedScene = preload("res://scenes/buildings/building.tscn")

## Positioning objects
var hovered_gridcell: Vector2i	# Highlighted center position


#region built in functions
func _ready() -> void:
	_initialize_main_scene()


func _process(_delta: float) -> void:
	grid_manager.get_mouse_on_grid_pos()
	cursor.global_position = grid_manager.grid_position * Stats.grid_size
	
	if cursor.visible:
		if hovered_gridcell == null or hovered_gridcell != grid_manager.grid_position:
			hovered_gridcell = grid_manager.grid_position
			grid_manager.highlight_valid_cells(hovered_gridcell, Stats.radi)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		# Check if highlight pos has value
		if hovered_gridcell != null:
			# Check if there already is a building
			if grid_manager.is_tile_available(hovered_gridcell):
				_place_builging_at_hovered_cell()
				cursor.visible = false

#endregion


#region private
func _initialize_main_scene():
	place_building_button.pressed.connect(_on_place_building_pressed)
	cursor.visible = false


## Place a building instance on mouse position
func _place_builging_at_hovered_cell() -> void:
	if hovered_gridcell == null:
		return
	
	var building_inst: Node2D = building_scene.instantiate()
	building_inst.global_position = hovered_gridcell * Stats.grid_size
	add_child(building_inst)
	
	# Add grid_position to dict
	grid_manager.mark_tile_as_occupied(hovered_gridcell)
	
	# Clear highlighted area once building is placed
	grid_manager.highlight_tilemap.clear()

#endregion


#region signal functions
func _on_place_building_pressed() -> void:
	cursor.visible = not cursor.visible

#endregion
