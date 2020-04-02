extends Spatial

var drone_scene = preload("res://Scenes/Drone.tscn")

var timer = 0.001
var queue = []
var clusters = {}

func _ready():
	randomize()
	for _i in range(Globals.NUM_OF_DRONES):
		var new_drone = drone_scene.instance()
		new_drone.translate(Vector3(
			randi() % 300 - 150,
			randi() % 50 - 25,
			randi() % 300 - 150
		))
		
		Globals.drones.append(new_drone)
		self.add_child(new_drone)

	group_drones()

# Group drones by just dealing cards
func group_drones():
	# Create arrays for the clusters in a dict
	for i in range(Globals.NUM_OF_CLUSTERS):
		clusters[i] = []

	# Deal each drone to a cluster
	for i in range(Globals.drones.size()):
		var drone = Globals.drones[i]
		var cluster = i % Globals.NUM_OF_CLUSTERS

		clusters[cluster].append(drone)

		# Add drone objects to a lookup table
		Globals.drone_cluster_lookup[drone] = cluster

	# Color them
	for cluster in clusters.values():
		var color = Color(
			rand_range(0, 1),
			rand_range(0, 1),
			rand_range(0, 1)
		)
		
		var material = SpatialMaterial.new()
		material.albedo_color = color
		
		for drone in cluster:
			drone.get_child(0).material = material
