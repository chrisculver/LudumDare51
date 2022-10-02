extends Control


func set_points(pts):
	$VBoxContainer/HBoxContainer/Label.text = " x" + str(pts)

func set_dirt(amount):
	$VBoxContainer/HBoxContainer2/Label.text = " x" + str(amount)
