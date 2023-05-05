extends Control
class_name UiInfo


onready var Card = $Card
onready var Close = $Close
onready var Ubi = $Ubi


func _ready():
	hide()


func PutCardVisible(card):
	show()
	Ubi.hide()
	Card.ChangeValues(card)

#func putUbiVisible(ubi):
#	show()
#	Card.hide()
#	Ubi.ChangeValues(ubi)
#	Ubi.show()

func _on_Close_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			hide()
