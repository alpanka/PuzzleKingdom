class_name GridManager
extends Node

## Export nodes
@export var base_terrain_tilemap: TileMapLayer
@export var highlight_tilemap: TileMapLayer

## Positions
var mouse_position: Vector2		# Mouse global position
var grid_position: Vector2i		# Mouse grid based position

## Data containers
var occupied_tiles: Dictionary = {} # Hashset. Stores occupied cells' coord.


## Highlight around each "BuildingComponent"
## Based on their "pos" and "radi"
func highlight_buildable_tiles() -> void:
	# Clear highlight tilemap
	clear_tilemap(highlight_tilemap)
	
	# Get all "BuildingComponent" from group
	var building_components\
		= get_tree().get_nodes_in_group(Names.group_building_component)\
		as Array[BuildingComponent]
	
	for component in building_components:
		var area_origin: Vector2i = component.get_grid_cell_pos()
		var area_radi: int = component.buildable_radi
		
		_highlight_valid_cells(area_origin, area_radi)
	

## Set highlight are based on "origin" with given "radi"
func _highlight_valid_cells(origin: Vector2i, radius: int) -> void:
	
	# Iterate on X and Y up to radius value
	for i in range(origin.x - radius, origin.x + radius + 1):
		for j in range(origin.y - radius, origin.y + radius + 1):
			var new_tile_pos: Vector2i = Vector2i(i, j)

			# if tile is occupied, skip this iteration
			if is_tile_available(new_tile_pos) == false: 
				continue
			
			highlight_tilemap.set_cell(new_tile_pos, 0, Vector2i.ZERO)


## Get mouse position snapped on grid.
## Need to multiply by grid_size
func get_mouse_on_grid_pos() -> Vector2i:
	mouse_position = highlight_tilemap.get_global_mouse_position()
	grid_position = floor(mouse_position / Stats.grid_size)
	return Vector2i(grid_position)


## Adds given Vector2 as occupied
func mark_tile_as_occupied(tile: Vector2i) -> void:
	occupied_tiles.get_or_add(tile)


## Return true if is a valid tile
## Return false if tile cannot be used
func is_tile_available(tile_pos: Vector2i) -> bool:
	# Get tile data on given coord
	var tile_data: TileData = base_terrain_tilemap.get_cell_tile_data(tile_pos)

	# False, if tile does not have any data -> no tile on given coord
	if tile_data == null: return false
	# False, if buildable marked as "false"
	if tile_data.get_custom_data("buildable") == false: return false
	# False, if coord in occupied_tiles
	return not occupied_tiles.has(tile_pos)


# Clears the "tilemap_layer"
func clear_tilemap(tilemap_layer: TileMapLayer) -> void:
	tilemap_layer.clear()
