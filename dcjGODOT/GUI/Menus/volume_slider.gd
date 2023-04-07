@tool

extends HBoxContainer

@export var bus_name : String
var active_bus
var dragging : bool

var last_time_polled: float = 0
var polling_interval : float = 200 #msec

@onready var active_slider = $VolumeControl

# Called when the node enters the scene tree for the first time.
func _ready():
	$BusName.text = bus_name

	if !Engine.is_editor_hint():
		active_bus = AudioServer.get_bus_index(bus_name)
		active_slider.value = db_to_linear(AudioServer.get_bus_volume_db(active_bus))
		$AudioStreamPlayer.bus = bus_name

func _process(_delta):
	if !Engine.is_editor_hint():
		if dragging:
			var msec = Time.get_ticks_msec()
			if msec > last_time_polled + polling_interval:
				last_time_polled = msec
				var volumeLinear = active_slider.value
				var volumeDB = linear_to_db(volumeLinear)
				AudioServer.set_bus_volume_db(active_bus, volumeDB)


func _on_volume_control_drag_started():
	dragging = true
	#$AudioStreamPlayer.play()


func _on_volume_control_drag_ended(_value_changed):
	dragging = false
	#$AudioStreamPlayer.stop()
