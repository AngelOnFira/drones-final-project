extends Node

var NUM_OF_DRONES = 10
var NUM_OF_CLUSTERS = int((sqrt(8 * NUM_OF_DRONES + 1) - 1) / 2)
var DRONES_PER_CLUSTER = int(NUM_OF_DRONES / NUM_OF_CLUSTERS)
var REMAINDER_DRONES = NUM_OF_DRONES % NUM_OF_CLUSTERS

var drone_cluster_lookup = {}
var channel_head_lookup = {}

var drones = []
var area = [100, 100, 100]

var transfer_rate_upper = 150000
var transfer_rate_lower = 50000
