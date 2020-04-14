extends Node

const NUM_OF_DRONES = 100
const NUM_OF_CLUSTERS = int((sqrt(8 * NUM_OF_DRONES + 1) - 1) / 2)
const DRONES_PER_CLUSTER = int(NUM_OF_DRONES / NUM_OF_CLUSTERS)
const REMAINDER_DRONES = NUM_OF_DRONES % NUM_OF_CLUSTERS

var drone_cluster_lookup = {}
var channel_head_lookup = {}

var drones = []
var area = [100, 100, 100]
