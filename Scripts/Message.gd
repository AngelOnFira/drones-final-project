extends Node

var message_size
var remaining_transfer
var final_destination

var current_downloader
var current_uploader

func start():
    var my_channel = Globals.drone_cluster_lookup[current_uploader]
    var destination_channel = Globals.drone_cluster_lookup[final_destination]
    var my_channel_head = Globals.channel_head_lookup[my_channel]
    
    if my_channel == destination_channel:
        # If the message is in the same channel
        current_downloader = final_destination
    else:
        current_downloader = my_channel_head

    remaining_transfer = message_size

func upload(delta):
    var download_speed = current_downloader.download_rate
    var num_jobs = current_downloader.incoming_queue.size()
    var upload_speed = min(download_speed / num_jobs, current_uploader.upload_rate)

    remaining_transfer -= upload_speed

    if remaining_transfer <= 0:
        next_node()

func next_node():
    pass