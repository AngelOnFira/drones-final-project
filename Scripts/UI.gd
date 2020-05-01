extends Control

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Globals.total_messages_time.size() > 0:
		var total = 0

		for i in range(Globals.total_messages_time.size()):
			total += Globals.total_messages_time[i]

		var avg = total / Globals.total_messages_time.size()
		$Panel/Htotal/Sliders/AvgCurrent.set_text("Last %d Message Average: %d" % [Globals.LAST_AVG_NUM, avg])
		
		avg = Globals.total_messages_culm / Globals.total_messages_arrived
		$Panel/Htotal/Sliders/AvgOverall.set_text("Total Average: %d" % avg)


func _on_Start_pressed():
	var drone_count = $Panel/Htotal/Sliders/Drones/Count.text

	if drone_count.is_valid_integer():
		Globals.NUM_OF_DRONES = int(drone_count)
	else:
		$Panel/Htotal/Sliders/Drones/Count.set_text(str(Globals.NUM_OF_DRONES))
