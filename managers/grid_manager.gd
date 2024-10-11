class_name GridManager
extends Node

@export var base_terrain_tilemap: TileMapLayer
@export var highlight_tilemap: TileMapLayer

var grid_size: int = 64

## Positions
var mouse_position: Vector2		# Mouse global position
var grid_position: Vector2		# Mouse grid based position

## Data containers
var occupied_tiles: Dictionary = {} # Hashset. Stores occupied cells' coord.


## Sets highlight area with defined radi on valid tiles
func highlight_valid_cells(origin: Vector2, radius: int) -> void:
	# Clear before you draw
	highlight_tilemap.clear()
	
	# Iterate on X and Y by radius
	for i in range(origin.x - radius, origin.x + radius + 1):
		for j in range(origin.y - radius, origin.y + radius + 1):
			if is_tile_available(Vector2(i, j)) == false: # if tile is occupied
				continue
			
			highlight_tilemap.set_cell(Vector2i(i, j), 0, Vector2i(0, 0))


## Get mouse position snapped on grid.
## Need to multiply by grid_size
func get_mouse_on_grid_pos() -> Vector2:
	mouse_position = highlight_tilemap.get_global_mouse_position()
	grid_position = floor(mouse_position / grid_size)
	return grid_position


## Adds given Vector2 as occupied
func mark_tile_as_occupied(tile: Vector2) -> void:
	occupied_tiles.get_or_add(tile)


## Return true if is a valid tile
func is_tile_available(tile: Vector2) -> bool:
	return not occupied_tiles.has(tile)
