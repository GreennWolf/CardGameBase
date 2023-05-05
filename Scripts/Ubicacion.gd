extends Node
class_name Ubicacion

var ubi = load("res://ScriptableObjets/ColinaDelTrueno.tres")

onready var UbiBase = $UbiBase
onready var Artwork = $Artwork
onready var UbiName = $UbiName
onready var EnemyPowerRect = $EnemyPowerRect
onready var EnemyPower = $EnemyPowerRect/EnemyPower
onready var PlayerPowerRect = $PlayerPowerRect
onready var PlayerPower = $PlayerPowerRect/PlayerPower
onready var HabDesct = $HabDesc
onready var PlayerCardZone = $PlayerCardZone
onready var EnemyCardZone = $EnemyCardZone
onready var EnemyCard1 = $EnemyCardZone/Card
onready var EnemyCard2 = $EnemyCardZone/Card2
onready var EnemyCard3 = $EnemyCardZone/Card3
onready var EnemyCard4 = $EnemyCardZone/Card4
onready var EnemyCard1Power = $EnemyCardZone/Card/Power
onready var EnemyCard2Power = $EnemyCardZone/Card2/Power
onready var EnemyCard3Power = $EnemyCardZone/Card3/Power
onready var EnemyCard4Power = $EnemyCardZone/Card4/Power

func _ready():
	UbiBase.texture = ubi.ubiBase
	Artwork.texture = ubi.artwork
	UbiName.text = ubi.ubiName
	EnemyPowerRect.color = ubi.enemyPowerRect
	EnemyPower.text = ubi.enemyPower 
	PlayerPowerRect.color = ubi.playerPowerRect
	PlayerPower.text = ubi.playerPower 
	HabDesct.text = ubi.habDesct

func Hability(cardPower):
	var newCardPower = ubi.habilidad.new().Execute(cardPower)
	return newCardPower

func ChangeValues(ubiT):
	print(ubiT)
	UbiBase.texture = ubiT.get_node('UbiBase').texture
	Artwork.texture = ubiT.get_node('Artwork').texture
	UbiName.text = ubiT.get_node('UbiName').text
	EnemyPowerRect.color = ubiT.get_node('EnemyPowerRect').color
	EnemyPower.text = ubiT.get_node('EnemyPowerRect').get_node('EnemyPower').text
	PlayerPowerRect.color = ubiT.get_node('PlayerPowerRect').color
	PlayerPower.text = ubiT.get_node('PlayerPowerRect').get_node('PlayerPower').text
	HabDesct.text = ubiT.get_node('HabDesc').text

