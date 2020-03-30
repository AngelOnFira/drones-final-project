extends Spatial

var drone_scene = preload("res://Scenes/Drone.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(100):
		print("Creating ", i)
		var new_drone = drone_scene.instance()
		new_drone.translate(Vector3(
			randi() % 100 - 50,
			randi() % 100 - 50,
			randi() % 100 - 50
		))
		self.add_child(new_drone)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
