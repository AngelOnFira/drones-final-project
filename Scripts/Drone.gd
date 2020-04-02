extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var message_queue = []

var time_until_next_message = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_time_next_message()

func roll_time_next_message():
	self.time_until_next_message = rand_range(1,11)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
