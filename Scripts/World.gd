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
            randi() % Globals.area[0] - Globals.area[0] / 2,
            randi() % Globals.area[1] - Globals.area[1] / 2,
            randi() % Globals.area[2] - Globals.area[2] / 2
        ))
        
        Globals.drones.append(new_drone)
        self.add_child(new_drone)

    kmeans()

func kmeans():
    for i in range(Globals.NUM_OF_CLUSTERS):
        clusters[i] = []
    
    var centroids = []
    var drones_available = Globals.drones.duplicate()
    
    for cluster_num in range(Globals.NUM_OF_CLUSTERS):
        # Get cluster size, account for remainder drones
        var cluster_size = Globals.DRONES_PER_CLUSTER
        if cluster_num < Globals.REMAINDER_DRONES:
            cluster_size += 1

        # Pick the centroids
        var this_centroid = Vector3(
            randi() % Globals.area[0] - Globals.area[0] / 2,
            randi() % Globals.area[1] - Globals.area[1] / 2,
            randi() % Globals.area[2] - Globals.area[2] / 2
        )
        centroids.append(this_centroid)
        
        var closest_drones = []
        
        for drone_num in drones_available.size():
            var distance = this_centroid.distance_squared_to(Vector3(
                drones_available[drone_num].translation.x,
                drones_available[drone_num].translation.y,
                drones_available[drone_num].translation.z
            ))

            if closest_drones.size() == 0:
                # Add the drone automatically if it's the only one so far
                closest_drones.insert(0, [distance, drones_available[drone_num], drone_num])
            else:
                # Search through the list to see if it can fit
                var found_place = false
                for i in range(closest_drones.size()):
                    if distance < closest_drones[i][0]:
                        closest_drones.insert(i, [distance, drones_available[drone_num], drone_num])
                        found_place = true
                        break

                # Add to the end if it didn't fit anywhere else. The loop abover doesn't do this
                if !found_place:
                    closest_drones.append([distance, drones_available[drone_num], drone_num])

                # If we're over size, remove the last element
                if closest_drones.size() > cluster_size:
                    closest_drones.pop_back()
        
        # The drone closest to the centroid is the Channel Head
        Globals.channel_head_lookup[cluster_num] = closest_drones[0][1]
        
        # Make a list of all the drones to remove
        var remove_list = []
        for i in range(closest_drones.size()):
            clusters[cluster_num].append(closest_drones[i][1])
            
            # Add drone objects to a lookup table
            Globals.drone_cluster_lookup[closest_drones[i][1]] = cluster_num

            remove_list.append(closest_drones[i][2])

        # Sort and invert the indicies so removal happens from
        # largest first, and doesn't shift the array while we're removing
        remove_list.sort()
        remove_list.invert()

        for i in range(remove_list.size()):
            drones_available.remove(remove_list[i])

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
