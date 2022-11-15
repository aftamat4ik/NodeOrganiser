class_name OrganiseHelpers

# Default godot's get_children() dosen't return nested child nodes
# This one returns all of them
static func collect_children(in_node:Node, arr:Array = []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = collect_children(child, arr)
	return arr

# Gdscript somehow dosen't support 2d arrays by default so i have to use this instead
# usage:
# var a = DA_QuickRefs.create_2d_array(5,2)
# a[3][1] = 2
static func create_2d_array(w, h):
	var map = []

	for x in range(w):
		var col = []
		col.resize(h)
		map.append(col)

	return map