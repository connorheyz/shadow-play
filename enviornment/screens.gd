extends VBoxContainer

var main: bool = false
var buttonFlag: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	
	if(event.is_action_pressed("ui_cancel",false)):
		_menu(event)
	
		
func _menu(event:InputEvent):
	if(event.as_text() == "Escape"):
		print(main)
		if(main == false):
			#print("hi")
			$".".visible = true
			main = true
		elif(main == true):
			#print("by")
			$".".visible = false
			main = false
			
	#print("hifdsfdsfds")


func _on_level_select_button_down() -> void:
	print("YIPPIE")
