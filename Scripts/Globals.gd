extends Node

const NUM_OF_DRONES = 1000
const NUM_OF_CLUSTERS = int((sqrt(8 * NUM_OF_DRONES + 1) - 1) / 2)
const DRONES_PER_CLUSTER = int(NUM_OF_DRONES / NUM_OF_CLUSTERS)
const REMAINDER_DRONES = NUM_OF_DRONES % NUM_OF_CLUSTERS

# In bytes/second
const RECEPTION_RATE = 10000

# In bytes/second
const TRANSMISSION_RATE = 10000

var drone_cluster_lookup = {}
var drones = []
var area = [100, 100, 100]
