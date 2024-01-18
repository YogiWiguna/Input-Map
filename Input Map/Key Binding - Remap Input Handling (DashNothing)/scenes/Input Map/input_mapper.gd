extends Control

@onready var input_button_scene = preload("res://scenes/Input Button/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

# Rebind the input action on the Input Map 
var input_actions = {
	"move_up": "Move Up",
	"move_down": "Move Down",
	"move_right": "Move Right",
	"move_left": "Move Left",
	"interact": "Interact"
}


func _ready():
	creation_action_list()

## Showing the InputMap that we decalre on the input_actions variable
func creation_action_list():
	# TO load the default input setting
	InputMap.load_from_project_settings()
	
	# Make Sure action_list is empty
	for item in action_list.get_children():
		item.queue_free()
	
	# Looping the input_actions dictionary
	for action in input_actions:
		# Create a new button to show on the action_list 
		var button = input_button_scene.instantiate()
		
		# Find the "LabelAction" and "LabelInput" 
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		
		# Change the action_label.text into the input_action[action] 
		action_label.text = input_actions[action]
		
		# Get the InputMap action fot change the input_label 
		var events = InputMap.action_get_events(action)
		
		#Checking if the events size is more then 0 
		if events.size() > 0:
			# With events[0].as_text() : Calling the value index 0 from events variable 
			# and return into representation of the event 
			# trim_suffix is removes the given suffix from the end of the string
			# in this case is " (Physical)" (Must contain the space) --> print(events[0].as_text() 
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			
		else: 
			input_label.text = ""
		
		# add button variable into the child of the action_list variable on the node
		action_list.add_child(button)
		
		# When the button is pressed connect it into the function _on_input_button_pressed
		# with button and action as the parameters. bind funtion is to 
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
# Remapping functionality to the buttons 
func _on_input_button_pressed(button, action):
	# If is not remapping, run the function inside
	if !is_remapping:
		# make the is_remapping into true
		is_remapping = true
		# Make the action value into the action_to_remap variable
		action_to_remap = action
		print(action_to_remap)
		# Make the remapping_button value into the remapping_button variable
		remapping_button = button
		print(remapping_button)
		# When button is pressed. change the text on the label_input into "Press key to bind..."
		button.find_child("LabelInput").text = "Press key to bind..."

# Checking the input function 
func _input(event):
	# Can change the input map if the is_remapping is true
	if is_remapping:
		if (
			# Checking the condition if the Input Map is Keyboard or Mouse Button 
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# Turn double click into single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			# Erase the InputMap events on variable action_to_remap  
			InputMap.action_erase_events(action_to_remap)
			# Add event input into the matching action_to_remap variable into the InputMap
			InputMap.action_add_event(action_to_remap, event)
			# Update the button into the new event that have been input by player
			_update_action_lists(remapping_button, event)
			print("Erase event : ", action_to_remap)
			print("Add event: ", action_to_remap,event)
			print("Update event: ", remapping_button, event)
			
			## Save with the update parameters ( I think for now)
			
			
			
			
			# Set the is_remaping into false again 
			is_remapping = false
			# Set the action_to_remap into null
			action_to_remap = null
			# Set the remapping_button into null
			remapping_button = null
			
			# Marks an input event as handled. Once you accept an input event,
			# it stops propagating
			accept_event()

# Update the button when changing
func _update_action_lists(button, event):
	# Update the button input and the text into the event that player input
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	creation_action_list()
