extends Spatial

# Die einzelnen Label-Nodes werden in Variablen gespeichert
onready var Bezeichnung_label = get_node("Interface/Infobox/Bezeichnung/Inhalt")
onready var Jahr_label = get_node("Interface/Infobox/Jahr/Inhalt")
onready var Etymologie_label = get_node("Interface/Infobox/Etymologie/Inhalt")
onready var Geschichte_label = get_node("Interface/Infobox/Geschichte/Inhalt")
onready var Textbeispiel_label = get_node("Interface/Infobox/Textbeispiel/Inhalt")
onready var iBox = get_node("Interface/Infobox")

# Index-Variablen für den unteren Model-/Package-Loader
var modelIndex = 0;
var infoIndex = 0;
var currentInfo
var currentModel
var illustration = Image.new()
var InputSpeichern = false

# Initialisiert Listenvariablen für die spätere Zwischenspeicherung der Modellnamen und Inforboxdateien
onready var models = []
onready var infos = []

# Die Resourcepacks sowie das Modell und die Infoboxdaten vom Index == 0 werden beim Start geladen.
func _ready():
	
	# Package-Finder: Lädt die packages oder zips (nur für Export verwenden)
	var dir = Directory.new()
	var modelnames = []
	var path_packages = "Models/"
	# Wenn es den Unterordner Models im Programmordner gibt, werden die darin enthaltenen Modelle (.pck oder .zip) geladen.
	if dir.open(path_packages) == OK:
		print("Packagesuche: ")
		dir.list_dir_begin()
		var file_name = dir.get_next()
		# Lädt alle Modelle im Ordner "Models", wenn sie die Endung .pck oder .zip haben.
		# Gibt in der Konsole die gefundenen Modelle aus.
		while file_name != "":
			print(file_name)
			if ".pck" in file_name or ".zip" in file_name:
				print("Package gefunden: " + file_name)
				ProjectSettings.load_resource_pack(path_packages + file_name)
			file_name = dir.get_next()
	else:
		print("Beim Laden der Packages trat ein Fehler auf.")
	
	# Lädt alle .tscn-Datien im Ordner Models in die Liste models. Es werden also die konkreten Szenen mit den Modellen geladen.
	var path_models = "res://Models/"
	if dir.open(path_models) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Lädt alle Modelle, die nicht das Testmodell sind.
			if ".tscn" in file_name and file_name != "Testobjekt.tscn":
				print("Modell gefunden: " + file_name)
				modelnames.append(file_name.replace(".tscn", ""))
				models.append(path_models+file_name)
			file_name = dir.get_next()
	else:
		print("Beim Laden der Modelle trat ein Fehler auf.")
	print(modelnames)
	print(models)
	print("Es wurden "+str(len(models))+" Modelle geladen.")
	# Wenn im Models-Ordner keine Dateien enthalten sind, wird das Testmodell geladen.
	if models == []:
		modelnames = ["Testobjekt"]
		models = ["res://Models/Testobjekt.tscn"]
		
	# Lädt alle .tres-Dateien aus dem Ordner Infobox in die Liste infos.
	# Dateipfad ohne "res://" und beim Export die .tres-Dateien aussparen, sonst funktioniert das Speicher nicht,
	# > weil die .exe sonst die .tres immer aus der .pck laden will.
	# var path_infos = "res://Infobox/"
	var path_infos = "Infobox/"
	if dir.open(path_infos) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".tres" in file_name:
				if file_name.replace(".tres", "") in modelnames:
					print("Modell gefunden: " + file_name)
					infos.append(path_infos+file_name)
				else:
					# Gibt Warnung aus, wenn mehr Infoboxen als Modelle vorhanden sind und listet die fehlenden Modelle.
					print("Modell wurde nicht gefunden: " + file_name.replace(".tres", ".tscn"))
			file_name = dir.get_next()
	else:
		print("Beim Laden der Infoboxen trat ein Fehler auf.")
	print(infos)
	
	print("   !!!", len(infos), "//", len(models), "!!!!!    ")
	
	_setModel(modelIndex)
	update_Infobox_display(infoIndex)
	print("BILDTEST:")
	print(models[modelIndex].replace("res://Models","res://Illustrationen").replace(".tscn", ".jpg"))
	setIllustration(models[modelIndex].replace("res://Models","res://Illustrationen").replace(".tscn", ".jpg"))
	
	if models == ["res://Models/Testobjekt.tscn"]:
		get_node("Interface/Warnung").popup()
	pass

# Wird die Funktion nextModel() aufgerufen [aktiviert per Mausklick auf Button] wird das nächste Modell geladen.
func nextModel():
	# Wenn man gerade beim letzten Modell ist [Index == models.size()-1; da erster Index == 0], dann wird der Index wieder auf 0 gesetzt
	if modelIndex >= models.size()-1:
		modelIndex = 0
		infoIndex = 0
	# Wenn das nicht der Fall ist: modelIndex und infoIndex += 1
	else:
		modelIndex += 1
		infoIndex += 1
	# Das Modell und die Infoboxdaten werden auf den aktuellen Index gesetzt.
	_setModel(modelIndex)
	update_Infobox_display(infoIndex)
	# Hier wird die zum Modell passende jpg-Datei als Illustration geladen.
	setIllustration(models[modelIndex].replace("res://Models","res://Illustrationen").replace(".tscn", ".jpg"))
	pass
	
# Gleiches wie nextModel() nur umgedreht.
func prevModel():
	if modelIndex <= 0:
		modelIndex = models.size()-1
		infoIndex = infos.size()-1
	else:
		modelIndex -= 1
		infoIndex -= 1
	_setModel(modelIndex)
	update_Infobox_display(infoIndex)
	setIllustration(models[modelIndex].replace("res://Models","res://Illustrationen").replace(".tscn", ".jpg"))
	pass

# aktuelles Modell wird auf das Modell mit dem aktuellen Index gesetzt [model = models[index].instance()]; currentModel = model
func _setModel(index):
	var model = load(models[index]).instance()
	if currentModel != null:
		# löscht das vorherige Modell.
		currentModel.queue_free()
	#add_child(model) fügt Modell [Wurzelnode der jew. Modell-Szene] unterhalb des Nodes "ModelViewer" ein
	#add_child(model)
	get_node("CameraController/modelContainer/model").add_child(model)
	#Fügt den Wurzelnode aus der jeweilig aktuellen Modell-Szene unter dem Node "CameraController" ein > direkt ins Zentrum
	#Unterhalb von CameraController funktioniert Steuerung aber nicht
	#get_node("CameraController/ModelContainer").add_child(model)
	currentModel = model
	get_node("Interface/MarginContainer/Objektbezeichung").text = models[modelIndex].replace("res://Models/", "").replace(".tscn", "")
	pass

# Setzt die Infobox-Labels auf den aktuellen Index-Wert
	# Dateipfad ohne "res://" und beim Export die .tres-Dateien aussparen, sonst funktioniert das Speicher nicht,
	# > weil die .exe sonst die .tres immer aus der .pck laden will
func update_Infobox_display(index):
	currentInfo = ResourceLoader.load(infos[index])
	Bezeichnung_label.text = currentInfo.Bezeichnung
	Jahr_label.text = str(currentInfo.Jahr)
	Etymologie_label.text = currentInfo.Etymologie
	Geschichte_label.text = currentInfo.Geschichte
	Textbeispiel_label.text = currentInfo.Textbeispiel
	pass

func setIllustration(Bildpfad):
	# Mein erster Versuch Bilder zu laden; funktioniert aber nur mit importierten Bildern; es können keine neuen in die EXE geladen werden.
		#illustration = ResourceLoader.load(Bildpfad)
		#illustration = load(Bildpfad)
		#get_node("Interface/MarginBild/Bild").texture = illustration
	
	# Möglichkeit Bilddateien ohne vorherigen Import zu verwenden:
	# Öffnet die Bilddatei
	var datei = File.new()
	if datei.file_exists(Bildpfad):
		datei.open(Bildpfad, File.READ)
		# Die Variable illustration ist vom Typ Image; das Bild wird hier aus der oben geöffneten Datei geladen
		illustration.load_jpg_from_buffer(datei.get_buffer(datei.get_len()))
		datei.close()
	else: # Wenn es keine zum Modell passende Bilddatei gibt, wird Platzhalter.jpg geladen.
		datei.open("res://Illustrationen/Platzhalter.jpg", File.READ)
		illustration.load_jpg_from_buffer(datei.get_buffer(datei.get_len()))
		datei.close()
	# Variable mit dem Typ ImageTextur, aus illustration wird eine Textur geschaffen.
	var textur = ImageTexture.new()
	textur.create_from_image(illustration)
	#illustration.lock()
	get_node("Interface/MarginBild/Bild").texture = textur
	pass
	
# Steuert Input
func _input(event):
	# Macht Infobox sichtbar/unsichtbar.
	# "Infoboxanzeigen" ist Keyboard-Input definiert unter Projekt > Projekteinstellungen > Eingabe-Zuordnung.
	if event.is_action_pressed("Infoboxanzeigen"):
		if get_node("Interface/Infobox").visible == true:
			get_node("Interface/Infobox").hide()
		else:
			get_node("Interface/Infobox").show()
			# "Infoboxanzeigen" ist Keyboard-Input definiert unter Projekt > Projekteinstellungen > Eingabe-Zuordnung.
	# Macht Bild sichtbar/unsichtbar.
	if event.is_action_pressed("Bildanzeigen"):
		if get_node("Interface/MarginBild").visible == true:
			get_node("Interface/MarginBild").hide()
		else:
			get_node("Interface/MarginBild").show()
	# Macht ganzes User-Interface sichtbar/unsichtbar.
	if event.is_action_pressed("InterfaceVerstecken"):
		if get_node("Interface/MarginContainer").visible == true:
			get_node("Interface/MarginContainer").hide()
		else:
			get_node("Interface/MarginContainer").show()
	#UserInput-Handler für Textfeld. Wird aktiviert, wenn die Eingabe-Taste gedrückt wird.
	if event.is_action_pressed("TextfeldSpeichern"):
		#Iteriert über alle Kinder des Infobox-Nodes.
		for node in get_node("Interface/Infobox").get_children():
			var nodechildName = node.get_name()
			var InhaltEingabe = get_node("Interface/Infobox/"+nodechildName+"/Inhalt_Eingabe")
			var Inhalt = get_node("Interface/Infobox/"+nodechildName+"/Inhalt")
			var txtLabel = InhaltEingabe.get_text()
			#Wenn das Eingabefeld nicht leer ist, wird das Inhaltslabel mit dem neuen Inhalt überschrieben und das Eingabefeld geleert.
			if txtLabel != "":
				Inhalt.set_text(txtLabel)
				#Setzt das Infobox-Datum bei der aktuellen Variable (mit dem Namen von nodechildName) auf txtLabel.
				currentInfo.set(nodechildName, txtLabel)
				#Speichert die Eingabe in die tres-Datei.
				ResourceSaver.save(infos[infoIndex], currentInfo)
				InhaltEingabe.set_text("")
		
func Warnhinweis_schliessen():
	get_node("Interface/Warnung").hide()

# Fkt ist obsolet; ehemals für OptionsButton zuständig. Diese Fkt wird jetzt im Skript MenuPopup.gd ausgeführt
func MenuAufruf():
	get_node("Interface/MarginContainer/MenuPopup").popup_centered()

func InfoboxExklusiv(Maus):
	if get_node("Interface/Infobox").visible == true:
		if Maus == "enter":
				get_tree().get_root().set_process_input(false)
				get_tree().paused = true
				print(Maus)
		elif Maus == "exit":
			if get_node("Interface/Infobox").visible == true:
				get_tree().get_root().set_process_input(true)
				get_tree().paused = false
			print(Maus)
	else:
		get_tree().get_root().set_process_input(true)
		get_tree().paused = false
		pass

# Versuch der Funktion für die Hintergrundfarbe.
# Nicht funktionsfähig
func setBackground(colour):
	if colour == "green":
		VisualServer.set_default_clear_color(Color(0.4,0.4,0.4,1.0))
	elif colour == "black":
		ProjectSettings.set_setting("rendering/environment/default_clear_color", "000000")
