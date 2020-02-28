tool
extends Control

signal waypoint_editor_enabled(value)
signal export_waypoints()

func _on_enable_button_pressed():
	emit_signal("waypoint_editor_enabled", true)
	get_node("Label").text = "Enabled"

func _on_disable_button_pressed():
	emit_signal("waypoint_editor_enabled", false)
	get_node("Label").text = "Disabled"

func _on_export_button_pressed():
	emit_signal("export_waypoints")
