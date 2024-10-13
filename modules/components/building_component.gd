class_name BuildingComponent
extends Node2D

@export var buildable_radi: int = 3


func _ready() -> void:
	self.add_to_group(Names.group_building_component)


func get_grid_cell_pos() -> Vector2i:
	var grid_position = floor(self.global_position / Stats.grid_size)
	return Vector2i(grid_position)
