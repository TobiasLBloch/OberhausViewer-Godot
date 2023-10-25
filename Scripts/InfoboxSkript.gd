extends RichTextLabel
# Obsolet? In ModelViewer.gd integriert?

onready var Bezeichnung_label = get_node("Interface/Infobox/Bezeichnung/Inhalt")
onready var Datum_label = get_node("Interface/Infobox/Datum/Inhalt")
onready var Etymologie_label = get_node("Interface/Infobox/Etymologie/Inhalt")
onready var Geschichte_label = get_node("Interface/Infobox/Geschichte/Inhalt")
onready var Textbeispiel_label = get_node("Interface/Infobox/Textbeispiel/Inhalt")

		
func _ready():
	var Infobox_data = load("res://Armbrust.tres")
	update_Infobox_display(Infobox_data)

func update_Infobox_display(Infobox_data):
	Bezeichnung_label.text = Infobox_data.Bezeichnung
	Datum_label.text = str(Infobox_data.Datum)
	Etymologie_label.text = Infobox_data.Etymologie
	Geschichte_label.text = Infobox_data.Geschichte
	Textbeispiel_label.text = Infobox_data.Textbeispiel
	
var iBox = get_tree().get_root().get_node("Interface/Infobox")
