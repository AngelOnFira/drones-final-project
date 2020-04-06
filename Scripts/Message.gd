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

func start():
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
    
    update_visual_link()

func update_visual_link():
    if visual_link:
        get_child(0).queue_free()
        
    visual_link = CSGCylinder.new()
    self.add_child(visual_link)
    
    visual_link.global_translate((current_downloader.translation + current_uploader.translation) / 2)
    
    visual_link.look_at(
        current_downloader.translation,
        Vector3(0, 0, 0)
    )
    
    visual_link.rotate_x(deg2rad(90))
    visual_link.set_scale(Vector3(1, 100, 1))
    # look at one
    # scale to half the distance

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

func next_node():
    var current_channel = Globals.drone_cluster_lookup[current_downloader]
    
    current_uploader.outgoing_queue.pop_front()

    var download_queue = current_downloader.incoming_queue
    download_queue.remove(download_queue.find(self))
    
    # if we're at destination
    if current_downloader == final_destination:
        self.queue_free()
        print("message recieved")
        return

    current_uploader = current_downloader
    remaining_transfer = message_size

    if current_channel == starting_channel:
        # if we're at our cluster head
        current_downloader = destination_channel_head
    else:
        # if we're at their cluster head
        current_downloader = final_destination

    current_downloader.incoming_queue.append(self)
    update_visual_link()
