extends Label

@export var counter_noise:AudioStreamPlayer3D

var number_to_display: int = 0
var time: float = 1.0
var main_text: String = ""

signal finish_display

var _counter: float = 0.0:
	set(value):
		_counter = value
		self.text = main_text + " " + str(int(_counter))
		counter_noise.play()

func _ready():
	main_text = text  # Save original label text

func set_number(value: int, duration: float):
	number_to_display = value
	time = duration

func display_number():
	_counter = 0
	var tween = create_tween()
	tween.tween_property(self, "_counter", number_to_display, time)
	tween.finished.connect(Callable(self, "emit_finish_signal"))

func emit_finish_signal():
	finish_display.emit()
	
