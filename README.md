# waypoint_editor

Godot example of how to edit custom waypoints.

This minimal example shows how to:
* Setup up an editor plugin for Godot
* Implement a dock with buttons for enable/disable and export
* Create waypoints on mouse clicks
* Export the waypoints to a Godot resources

Tested on Godot 3.2.

## known limitations

* The exporter can only handles waypoints that are at the lowest level of the scene. I.e. it doesn't traverse child nodes. We leave this as an exercise to the reader. ;)