tool
extends EditorPlugin

var organise_ui_instance

var _editor_interface:EditorInterface
var _edited_scene_root:Node
var _selected_node:Node

const categories_top_node = "Categorised"
const data_resource_path = "res://addons/node_organiser/Resources/OrganiseData.tres"

func _enter_tree():
	if organise_ui_instance == null:
		# initialise ui
		organise_ui_instance = preload("res://addons/node_organiser/Ui/OrganiseUI.tscn").instance()
		organise_ui_instance.connect("organise", self, "organise_selected_nodes")
		
		add_control_to_dock(DOCK_SLOT_RIGHT_UL, organise_ui_instance)

func _exit_tree():
	if organise_ui_instance != null:
		remove_control_from_docks(organise_ui_instance)

# restore layout
func set_window_layout(layout):
	if organise_ui_instance != null:
		# load saved organise rules
		var plugin_data = load_plugin_data()
		if plugin_data.organise_rules.length() > 0:
			organise_ui_instance.set_rules(plugin_data.organise_rules)

# save layout
func get_window_layout(layout):
	if organise_ui_instance != null:
		# save last state of rules
		var plugin_data = load_plugin_data()
		plugin_data.organise_rules = organise_ui_instance.get_rules()
		plugin_data.settings = organise_ui_instance.get_settings()
		# save changes
		ResourceSaver.save(data_resource_path, plugin_data)

# works every tyme user change currently selected node
func handles(object):
	if object is Node:
		# update selected node each handles
		_selected_node = get_selected_node()

# loads plugin data
func load_plugin_data()->Resource:
	return ResourceLoader.load(data_resource_path)

# Clean-up old item categories
func clean_categories():
	var core = _selected_node.get_node_or_null(categories_top_node)
	if core != null:
		# call free() to destroy node immediately
		# this will also remove all subnodes so no need to loop thru all of them
		# core.free() # .queue_free() - async version of free()
		_selected_node.remove_child(core)

# main processing function
func organise_selected_nodes(text_rules:String, duplicate:bool, uniq_name:bool):
	_editor_interface = get_editor_interface()
	_edited_scene_root = _editor_interface.get_edited_scene_root()
	_selected_node = get_selected_node()

	# check if node is seleted
	if _selected_node == null or _selected_node.get_child_count() == 0:
		printerr("Node Organiser: No Subnodes Found in selected!")
		return
	
	# remove old category nodes
	if duplicate:
		clean_categories()

	# generate cats node if necessary
	var organised_cat = _selected_node.get_node_or_null(categories_top_node)
	if organised_cat == null:
		organised_cat = Spatial.new()
		
		# define core node name
		organised_cat.set_name(categories_top_node)
		# add node to list
		_selected_node.add_child(organised_cat)
		organised_cat.set_owner(_edited_scene_root)

	# load categories for each child

	# make list of nodes that are child of selected (_selected_node)
	# and then look if this nodes not part of categories
	# if so - categorise them
	var subnodes = OrganiseHelpers.collect_children(_selected_node)
	var lc_catname = categories_top_node.to_lower()

	var rules = text_rules.split("\n") as Array
	#rules = OrganiseRuleHelpers.sort_rules(rules)

	# rules should go from longest to shortest
	#rules.invert()

	# go thru all nodes on selected
	for node in subnodes:
		var l_node_path :String = (node.get_path() as String).to_lower()

		# check if this node not categorised yet (if it's categorised then it's path will have lc_catname in it)
		if node == _selected_node or l_node_path.find(lc_catname) != -1:
			continue
		
		for rule in rules:
			if OrganiseRuleHelpers.is_rule_valid(rule, node):
				
				# apply this category to node
				var cats = OrganiseRuleHelpers.get_rule_list_cats(rule)

				# generate cats subnodes
				# and store last node into subnode variable
				var subnode
				var target_node = organised_cat
			
				for cat in cats:
					subnode = target_node.get_node_or_null(cat)
					if subnode == null:
						subnode = Spatial.new()
						subnode.set_name(cat)
						target_node.add_child(subnode)
						subnode.set_owner(_edited_scene_root)
					
					# next node should attach to previous like in chain
					# for example Female-Body-Attachment should be like so:
					# Female
					# --Body
					# ----Attachment
					# we build up a tree here
					target_node = subnode
				#continue

				# set category for duplicated node
				var organisable_node_name = node.name + " [org]" if node.name.find("[org]") == -1 else node.name
				
				# if node is already organised or for some reason there is no target
				if target_node == null or target_node.has_node(organisable_node_name):
					continue
				
				var organised_node = node.duplicate() if duplicate else node
				
				# set new name to node
				if uniq_name:
					organised_node.name = organisable_node_name

				# we should remove node from it's current parent if set
				var old_parent = organised_node.get_parent()
				if old_parent != null:
					old_parent.remove_child(organised_node)
				
				target_node.add_child(organised_node)
				organised_node.set_owner(_edited_scene_root)

				# stop checks for this node
				break
	print("Organise Nodes: Done")

# selected nodes
func get_selected_nodes()->Array:
	return  get_editor_interface().get_selection().get_selected_nodes()

# selected node
func get_selected_node()->Node:
	var selected = get_selected_nodes()
	
	if not selected.empty():
		# Always pick first node in selection
		return selected[0]
	
	return null
