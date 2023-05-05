extends Node
class_name FuriaVikinga


func ready():
	pass
	
func Execute(poder , nodo):
	var new_power = int(poder) + 2
	nodo.text = String(new_power)
	print(new_power)
	return new_power
