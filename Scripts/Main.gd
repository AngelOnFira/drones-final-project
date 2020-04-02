extends Spatial

var drone_scene = preload("res://Scenes/Drone.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer = 0.001
var queue = []
var drones = []
var clusters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Globals.NUM_OF_DRONES):
		print("Creating ", i)
		var new_drone = drone_scene.instance()
		new_drone.translate(Vector3(
			randi() % 100 - 50,
			randi() % 100 - 50,
			randi() % 100 - 50
		))
		
		drones.append(new_drone)
		self.add_child(new_drone)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	
	if timer < 0.0:
		print(queue)
		queue.push_back("a")
		timer = 0.001
