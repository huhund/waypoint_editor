extends Resource

export(int) var num_waypoints
export(Array, Vector3) var waypoints

func _init():
	num_waypoints = 0
	waypoints = []
