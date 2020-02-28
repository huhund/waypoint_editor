tool
extends EditorPlugin

var dock
var enabled
const wpClass = preload("res://addons/waypoint_editor/waypoint_locator.gd")
const wpDataClass = preload("res://data/waypoint_data.gd")

# init the plugin
func _enter_tree():
	set_input_event_forwarding_always_enabled()
	dock = preload("res://addons/waypoint_editor/waypoint_dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)

# destroy the plugin
func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

# hook up the buttons
func _ready():
	dock.connect("waypoint_editor_enabled", self, "enabled_changed")
	dock.connect("export_waypoints", self, "export")

# for refernece: you need to either implment handles() or enable set_input_event_forwarding_always_enabled()
# otherwise forward_spatial_gui_input() won't be called
#func handles(object):
#	return true

# callback from dock
func enabled_changed(enable):
	print(enable)
	enabled = enable

# implement godot input
func forward_spatial_gui_input(camera, event):
	if !enabled:
		return false
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			var pos = camera.project_ray_origin(event.position)
			var dir = camera.project_ray_normal(event.position)
			var p = project_to_floor(pos, dir, 0)
			create_node(p)
			return true
	
	return false
	
# finds the zero height positin of the click
func project_to_floor(origin, ray, height):
	if ray.y == 0:
		return origin;
	
	var kx = -ray.x / ray.y
	var kz = -ray.z / ray.y
	origin = origin - Vector3(0,1,0) * height
	return Vector3(origin.x + kx * origin.y, height, origin.z + kz * origin.y);

# creates a new node from clicks
func create_node(pos):
	print(pos)
	var wp = preload("res://addons/waypoint_editor/waypoint.tscn").instance()
	var root = get_tree().get_edited_scene_root()
	root.add_child(wp)
	wp.set_owner(get_tree().get_edited_scene_root())
	wp.translation = pos
	wp.name = "WP" # godot will add postfix to name
	
func count_wps():
	var count = 0
	var children = get_tree().get_edited_scene_root().get_children()
	for node in children:
		if node is wpClass: 
			count += 1

	return count	

# saves the waypoints in a custom resources
func export():
	var res = wpDataClass.new()

	var count = 0
	var children = get_tree().get_edited_scene_root().get_children()
	for node in children:
		if node is wpClass:
			count += 1
			res.waypoints.push_back(node.translation)
			
	res.num_waypoints = count
	ResourceSaver.save("res://data/waypoint_data.tres", res)
	print(str(count) + " waypoints exported to data/waypoint_data.tres")
