extends Node2D

# La carta seleccionada actualmente
var selected_card = null
# El nodo Mano
var hand_node

onready var UiInfo = $UiInfo 
var clicked_card = null
var mouse_press_time = 0.0

var initial_mouse_position = Vector2()

var initial_card_position = Vector2()

var is_location_card = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hand_node = get_tree().get_root().find_node("Mano", true, false)

func _process(delta):
	if clicked_card and mouse_press_time != 0 and (OS.get_ticks_msec() - mouse_press_time) >= 200:
		selected_card = clicked_card
		selected_card.raise()
		selected_card.rect_min_size = selected_card.rect_size
		print("Mouse button held for more than 2 seconds")
		# Restablece el tiempo de presión del mouse y la referencia a la carta clickeada
		mouse_press_time = 0
		clicked_card = null


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var card = get_card_under_mouse()
			var location_card = get_card_in_location_under_mouse()
			var Ubi = get_ubi_under_mouse()

			if card:
				start_mouse_click(card, false)
			elif location_card:
				start_mouse_click(location_card, true)
				print(is_location_card)
			elif Ubi :
				print(Ubi,'UBI')
				#UiInfo.putUbiVisible(Ubi)
		elif not event.pressed and event.button_index == BUTTON_LEFT:
			finish_mouse_click()
			selected_card = null
	elif event is InputEventMouseMotion:
		move_selected_card()

func start_mouse_click(card, is_location):
	mouse_press_time = OS.get_ticks_msec()
	clicked_card = card
	is_location_card = is_location

func finish_mouse_click():
	if clicked_card:
		var elapsed_time = OS.get_ticks_msec() - mouse_press_time
		if elapsed_time < 100:
			UiInfo.PutCardVisible(clicked_card)
		clicked_card = null
		is_location_card = false
	mouse_press_time = 0
	if selected_card and not is_location_card:
		place_card_in_location()
		selected_card = null

func move_selected_card():
	if selected_card and not is_location_card:
		var current_mouse_position = get_global_mouse_position()
		selected_card.rect_global_position = initial_card_position + (current_mouse_position - initial_mouse_position)


func get_card_under_mouse():
	var objects = get_tree().get_nodes_in_group("cards")
	var mouse_position = get_local_mouse_position()
	for obj in objects:
		if obj is Control:
			var global_rect = obj.get_global_rect()
			if global_rect.has_point(mouse_position):
				if obj.get_parent() == hand_node:
					return obj
	return null

func get_ubi_under_mouse():
	var locations = get_tree().get_nodes_in_group("locations")
	var mouse_position = get_global_mouse_position()

	for location in locations:
		if location is Control:
			if location.get_global_rect().has_point(mouse_position):
				return location

func get_card_in_location_under_mouse():
	var locations = get_tree().get_nodes_in_group("locations")
	var mouse_position = get_global_mouse_position()

	for location in locations:
		if location is Control:
			if location.has_node("PlayerCardZone"):
				var player_card_zone = location.get_node("PlayerCardZone")
				var card_slots = player_card_zone.get_children()

				for slot in card_slots:
					if slot.name == "card_slot" or slot.name == "card_slot2" or slot.name == "card_slot3" or slot.name == "card_slot4":
						if slot.get_children():
							var card = slot.get_child(0)
							var card_global_position = card.get_global_position()
							var card_rect = card.get_rect()
							card_rect.size = Vector2(120,160)
							# Convierte las coordenadas locales del rectángulo a globales
							var card_global_rect = Rect2(card_global_position, card_rect.size)
							
							if card_global_rect.has_point(mouse_position):
								return card
	return null



func getPower(locationPower,cardPower):
	var newLocationPower = int(locationPower) + int(cardPower)
	return String(newLocationPower)
	

func place_card_in_location():
	var locations = get_tree().get_nodes_in_group("locations")
	var mouse_position = get_local_mouse_position()
	
	for location in locations:
		if location is Control:
			var global_rect = location.get_global_rect()
			if global_rect.has_point(mouse_position):
				if location.has_node("PlayerCardZone"):
					var player_card_zone = location.get_node("PlayerCardZone")
					var card_slots = player_card_zone.get_children()
					
					for slot in card_slots:
						if slot.name == "card_slot" or slot.name == "card_slot2" or slot.name == "card_slot3" or slot.name == "card_slot4":
							if not slot.get_children():
								print_card_slot_status(player_card_zone)
								var card_scene = load(selected_card.filename)
								var new_card = card_scene.instance()

								# Copia las propiedades de la carta original a la nueva instancia
								var label_names = ["Name", "Power", "Energy", "Description", "Habilidad"]
								for label_name in label_names:
									if selected_card.has_node(label_name) and new_card.has_node(label_name):
										var original_label = selected_card.get_node(label_name)
										var new_label = new_card.get_node(label_name)
										new_label.text = original_label.text

								# Copia la textura del nodo Artwork
								if selected_card.has_node("Artwork") and new_card.has_node("Artwork"):
									var original_artwork = selected_card.get_node("Artwork")
									var new_artwork = new_card.get_node("Artwork")
									new_artwork.texture = original_artwork.texture

								# Escala el nodo Card
								new_card.rect_scale = Vector2(0.6, 0.6) # Ajusta el valor para el tamaño deseado

								var new_card_power = new_card.get_node('Power')
								var PlayerPowerRect = location.get_node('PlayerPowerRect')
								var playerPower = PlayerPowerRect.get_node('PlayerPower')
								var EnemyPowerRect = location.get_node('EnemyPowerRect')
								var enemyPower = EnemyPowerRect.get_node('EnemyPower')
		
								var newPowerCard = location.Hability(new_card_power.text)
								if(newPowerCard != null && newPowerCard != ''):
									new_card_power.text = newPowerCard				
													
								var newPlayerPower = getPower(playerPower.text,new_card_power.text)

								playerPower.text = newPlayerPower
								
								if(int(playerPower.text) > int(enemyPower.text) ):
									PlayerPowerRect.color = "#E86A33"
								elif(int(playerPower.text) < int(enemyPower.text)):
									EnemyPowerRect.color = "#E86A33"
								
								slot.add_child(new_card)
								selected_card.queue_free()
								return




func print_card_slot_status(player_card_zone):
	var card_slots = player_card_zone.get_children()
	for slot in card_slots:
		if slot.name == "card_slot":
			if slot.get_children():
				print(slot, "ocupado")
			else:
				print(slot, "vacío")

func takeCard():
	var objects = get_tree().get_nodes_in_group("cards")
	var mouse_position = get_local_mouse_position()
	for obj in objects:
		if obj is Control:
			var global_rect = obj.get_global_rect()
			if global_rect.has_point(mouse_position):
				print(obj)
				return obj
	return null

