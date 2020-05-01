extends Node

var NUM_OF_DRONES = 100
var NUM_OF_CLUSTERS = int(round(sqrt(8 * NUM_OF_DRONES + 1) - 1) / 2)
var DRONES_PER_CLUSTER = int(NUM_OF_DRONES / NUM_OF_CLUSTERS)
var REMAINDER_DRONES = NUM_OF_DRONES % NUM_OF_CLUSTERS

var LAST_AVG_NUM = 200

var drone_cluster_lookup = {}
var channel_head_lookup = {}

var drones = []
var area = [100, 100, 100]

var transfer_rate_upper = 150000
var transfer_rate_lower = 50000

var total_messages_arrived = 0.0
var total_messages_culm = 0.0
var total_messages_time = []

var TIMES_TO_RUN = min(NUM_OF_CLUSTERS - 1, 5) * 2
var ITERATION_COUNTER = 0 - TIMES_TO_RUN / 2

var TIMER = 60
var TIME_ITERATION_REMAINING = TIMER

func refresh():
	print("--------------")
	print("Final average: %d" % (total_messages_culm / total_messages_arrived))
	print("Iterations remaining: %d" % TIMES_TO_RUN)
	print("--------------")

	drone_cluster_lookup = {}
	channel_head_lookup = {}
	drones = []
	
	total_messages_arrived = 0.0
	total_messages_culm = 0.0
	total_messages_time = []

	get_tree().reload_current_scene()
	get_tree().get_root().get_node("Main").get_node("Messages").queue_free()
