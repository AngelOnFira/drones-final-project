# This is taken from https://github.com/nimenko/godot-flying-camera-3d/blob/master/flying-camera/flying_camera.gd

extends Camera

export(float) var mouse_sensitivity = 0.0001
export(float) var camera_speed = 1

const X_AXIS = Vector3(1, 0, 0)
const Y_AXIS = Vector3(0, 1, 0)

var is_mouse_motion = false

var mouse_speed = Vector2()
var mouse_speed_x = 0
var mouse_speed_y = 0

onready var camera_transform = self.get_transform()


func _ready():
	set_physics_process(true)
	set_process_input(true)


func _physics_process(delta):	
	if (Input.is_key_pressed(KEY_W)):
		camera_transform.origin += -self.get_transform().basis.z * camera_speed
	
	if (Input.is_key_pressed(KEY_S)):
		camera_transform.origin += self.get_transform().basis.z * camera_speed
	
	if (Input.is_key_pressed(KEY_A)):
		camera_transform.origin += -self.get_transform().basis.x * camera_speed
	
	if (Input.is_key_pressed(KEY_D)):
		camera_transform.origin += self.get_transform().basis.x * camera_speed
	
	if (Input.is_key_pressed(KEY_Q)):
		camera_transform.origin += -self.get_transform().basis.y * camera_speed
	
	if (Input.is_key_pressed(KEY_E)):
		camera_transform.origin += self.get_transform().basis.y * camera_speed
	
	self.set_transform(camera_transform)


func _input(event):
	if (event is InputEventMouseMotion):
		is_mouse_motion = true
	
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
