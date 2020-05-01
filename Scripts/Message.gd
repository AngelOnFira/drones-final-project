extends Node

var message_size
var remaining_transfer
var final_destination

var destination_channel
var starting_channel
var destination_channel_head

var current_downloader
var current_uploader

var visual_link = null

var creation_time

var iteration_creation

func start():
	iteration_creation = Globals.TIMES_TO_RUN
	creation_time = OS.get_ticks_msec()

	starting_channel = Globals.drone_cluster_lookup[current_uploader]
	destination_channel = Globals.drone_cluster_lookup[final_destination]
	destination_channel_head = Globals.channel_head_lookup[destination_channel]
	var my_channel_head = Globals.channel_head_lookup[starting_channel]
	
	if starting_channel == destination_channel:
		# If the message is in the same channel
		current_downloader = final_destination
	else:
		current_downloader = my_channel_head

	current_uploader.outgoing_queue.push_back(self)
	current_downloader.incoming_queue.append(self)

	remaining_transfer = message_size
	
	visual_link = CSGSphere.new()
	visual_link.set_scale(Vector3(0.5, 0.5, 0.5))
	self.add_child(visual_link)

	visual_link.transform.origin = current_uploader.transform.origin
	
	update_visual_link()

func update_visual_link():
	var upload_percentage = 1 - remaining_transfer / message_size
	var nodes_mid_line = current_downloader.translation - current_uploader.translation
	
	visual_link.transform.origin = nodes_mid_line * upload_percentage + current_uploader.transform.origin

func upload(delta):
	var download_speed = current_downloader.download_rate
	var num_jobs = max(current_downloader.incoming_queue.size(), 1)
	var upload_speed = min(
		download_speed / num_jobs,
		current_uploader.upload_rate * delta
	)

	remaining_transfer -= upload_speed

	if remaining_transfer <= 0:
		next_node()

	update_visual_link()

func next_node():
	var current_channel = Globals.drone_cluster_lookup[current_downloader]
	
	current_uploader.outgoing_queue.pop_front()

	var download_queue = current_downloader.incoming_queue
	download_queue.remove(download_queue.find(self))
	
	# if we're at destination
	if current_downloader == final_destination:
		self.queue_free()
		
		Globals.total_messages_arrived += 1
		Globals.total_messages_culm += OS.get_ticks_msec() - creation_time
		Globals.total_messages_time.push_back(OS.get_ticks_msec() - creation_time)
		
		if Globals.total_messages_time.size() > Globals.LAST_AVG_NUM:
			Globals.total_messages_time.pop_front()
		return

	current_uploader = current_downloader
	remaining_transfer = message_size

	if current_channel == starting_channel:
		# if we're at our cluster head
		current_downloader = destination_channel_head
	else:
		# if we're at their cluster head
		current_downloader = final_destination

	current_uploader.outgoing_queue.push_back(self)
	current_downloader.incoming_queue.append(self)
	update_visual_link()
