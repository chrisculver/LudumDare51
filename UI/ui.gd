extends Control

var currentCapacity = 1
var maxCapacity = 1

@onready var progressBar = $MarginContainer/VBoxContainer/ProgressBar

func set_cows(amount):
	$MarginContainer/VBoxContainer/HBoxContainer0/HBoxContainer/Label.text = " x" + str(amount)

func set_dirt(amount):
	$MarginContainer/VBoxContainer/HBoxContainer0/HBoxContainer3/Label.text = " x" + str(amount)

func set_mibs(amount):
	$MarginContainer/VBoxContainer/HBoxContainer0/HBoxContainer2/Label.text = " x" + str(amount)

func set_current_capacity(amount):
	progressBar.value = amount
	currentCapacity = amount
	check_capacity()

func set_max_capacity(amount):
	progressBar.max_value = amount
	maxCapacity = amount
	check_capacity()

func check_capacity():
	var ratio = float(currentCapacity)/float(maxCapacity)
	if ratio <= 0.5:
		progressBar.get("theme_override_styles/fill").bg_color = Color.WEB_GREEN
	elif ratio <=0.9:
		progressBar.get("theme_override_styles/fill").bg_color = Color.YELLOW
	else:
		progressBar.get("theme_override_styles/fill").bg_color = Color.RED


