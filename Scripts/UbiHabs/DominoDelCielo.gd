extends Node
class_name DominoDelCielo

func _ready():
	pass 
	
func Execute(cardPower):
	if(int(cardPower) <= 3):
		var newCardPower = int(cardPower) + 1
		return String(newCardPower)
	else:
		return 
