extends Node
class_name Card

var card = load("res://ScriptableObjets/Bjorn.tres")

onready var myArtwork = $Artwork
onready var myCardBase = $CardBase
onready var myCardName = $Name
onready var myPower = $Power
onready var myEnergy = $Energy
onready var myDescription = $Description
onready var myHabilidad = $Habilidad

func _ready():
	myArtwork.texture = card.artwork
	myCardBase.texture = card.cardBase
	myCardName.text = card.name
	myPower.text = String(card.attack)
	myEnergy.text = String(card.energy)
	myDescription.text = card.description
	myHabilidad.text = card.habDescri
	print(card.habilidad.new().Execute(card.attack,myPower))
	

func ChangeValues(cardT):
	
	myArtwork.texture = cardT.get_node('Artwork').texture
	myCardBase.texture = cardT.get_node('CardBase').texture
	myCardName.text = cardT.get_node('Name').text
	myPower.text = String(cardT.get_node('Power').text)
	myEnergy.text = String(cardT.get_node('Energy').text)
	myDescription.text = cardT.get_node('Description').text
	myHabilidad.text = cardT.get_node('Habilidad').text

