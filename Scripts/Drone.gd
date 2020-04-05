extends Spatial

var message = load("Scripts/Message.gd")

var incoming_queue = []
var outgoing_queue = []

# In bytes/second
var download_rate = 10000

# In bytes/second
var upload_rate = 10000

var time_until_next_message = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_time_next_message()

func roll_time_next_message():
	#self.time_until_next_message = rand_range(1,11)
	self.time_until_next_message = 0.1

func send_message():
	var drones = Globals.drone_cluster_lookup.keys()

	var destination = self
	while destination == self:
		destination = drones[int(rand_range(0, drones.size()))]

	var new_message = message.new()

	new_message.final_destination = destination
	new_message.current_uploader = self
	new_message.message_size = 15000

	new_message.start()

	outgoing_queue.append(new_message)
	get_node('/root/Main/Messages').add_child(new_message)

func _process(delta):
	time_until_next_message -= delta
	if time_until_next_message <= 0.0:
		send_message()

	if outgoing_queue.size() > 0:
		outgoing_queue[0].upload(delta)