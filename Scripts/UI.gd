extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



func _on_Start_pressed():
    var drone_count = $Panel/Htotal/Sliders/Drones/Count.text

    if drone_count.is_valid_integer():
        Globals.NUM_OF_DRONES = int(drone_count)
    else:
        $Panel/Htotal/Sliders/Drones/Count.set_text(str(Globals.NUM_OF_DRONES))

    Globals.drone_cluster_lookup = {}
    Globals.channel_head_lookup = {}
    Globals.drones = []

    

    get_tree().reload_current_scene()
