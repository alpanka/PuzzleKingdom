extends Node

## Building cursor. Visible on building mode
@onready var cursor: Sprite2D = $Cursor
## Turn on/off building mode
@onready var place_building_button: Button = $PlaceBuildingButton
@onready var highlight_tilemap: TileMapLayer = $HighlightTileMap

var building_scene: PackedScene = preload("res://scenes/buildings/building.tscn")

var grid_size: int = 64

## Positioning objects
var mouse_position: Vector2		# Mouse global position
var grid_position: Vector2		# Mouse grid based position
var hovered_gridcell: Vector2	# Highlighted center position

## Data containers
var occupied_tiles: Dictionary = {} # Hashset. Stores occupied cells' coord.


#region built in functions
func _ready() -> void:
	_initialize_main_scene()


func _process(delta: float) -> void:
	_get_mouse_on_grid_pos()
	cursor.global_position = grid_position * grid_size
	
	if cursor.visible:
		if hovered_gridcell == null or hovered_gridcell != grid_position:
			hovered_gridcell = grid_position
			_update_highlight_tile()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		# Check if highlight pos has value
		if hovered_gridcell != null:
			# Check if there already is a building
			if occupied_tiles.has(hovered_gridcell) == false:
				_place_builging_at_hovered_cell()
				cursor.visible = false

#endregion


#region private
func _initialize_main_scene():
	place_building_button.pressed.connect(_on_place_building_pressed)
	cursor.visible = false


## Get mouse position snapped on grid.
## Need to multiply by grid_size
func _get_mouse_on_grid_pos() -> Vector2:
	mouse_position = highlight_tilemap.get_global_mouse_position()
	grid_position = floor(mouse_position / grid_size)
	return grid_position


## Place a building instance on mouse position
func _place_builging_at_hovered_cell() -> void:
	if hovered_gridcell == null:
		return
	
	var building_inst: Node2D = building_scene.instantiate()
	building_inst.global_position = hovered_gridcell * grid_size
	add_child(building_inst)
	
	# Add grid_position to dict
	occupied_tiles.get_or_add(hovered_gridcell)
	
	# Clear highlighted area once building is placed
	highlight_tilemap.clear()


## Sets highlight area around defined limit for hovered_cell
func _update_highlight_tile() -> void:
	# Radius of area
	var limit: int = 3
	
	# Clear before you draw
	highlight_tilemap.clear()
	
	if hovered_gridcell == null:
		return
	
	for i in range(hovered_gridcell.x - limit, hovered_gridcell.x + limit + 1):
		for j in range(hovered_gridcell.y - limit, hovered_gridcell.y + limit + 1):
			highlight_tilemap.set_cell(Vector2i(i, j), 0, Vector2i(0, 0))

#endregion


#region signal functions
func _on_place_building_pressed() -> void:
	cursor.visible = not cursor.visible

#endregion
