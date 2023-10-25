extends Popup

onready var player = get_tree().get_root()
var already_paused
var selected_menu

func change_menu_color():
	$Fenster_schliessen.color = Color.gray
	$Steuerung.color = Color.gray
	$Hintergrundfarbe.color = Color.gray
	$Bewegungsgeschwindigkeit.color = Color.gray
	$Neustarten.color = Color.gray
	$Ende.color = Color.gray
	
	match selected_menu:
		0:
			pass
		1:
			$Fenster_schliessen.color = Color.greenyellow
		2:
			$Steuerung.color = Color.greenyellow
		3:
			$Hintergrundfarbe.color = Color.greenyellow
		4:
			$Bewegungsgeschwindigkeit.color = Color.greenyellow
		5:
			$Neustarten.color = Color.greenyellow
		6:
			$Ende.color = Color.greenyellow

func OptionsButton():
	# Pause game
	already_paused = get_tree().paused
	get_tree().paused = true
	# Reset the popup
	selected_menu = 0
	change_menu_color()
	# Show popup
	player.set_process_input(false)
	popup()
	
func _input(event):
	if not visible:
		if Input.is_action_just_pressed("Menü"):
			if get_node("Steuerungsmenü").visible:
				get_node("Steuerungsmenü").hide()
				popup()
			elif get_node("Hintergrundfarbpopup").visible:
				get_node("Hintergrundfarbpopup").hide()
				popup()
			elif get_node("Bewegungsgeschwindigkeitspopup").visible:
				get_node("Bewegungsgeschwindigkeitspopup").hide()
				popup()
			else:
				# Pause game
				already_paused = get_tree().paused
				get_tree().paused = true
				# Reset the popup
				selected_menu = 0
				change_menu_color()
				# Show popup
				player.set_process_input(false)
				popup()
	else:
		# Weil die Pausierung bei Interaktion mit den Labels immer unterbrochen wurde, hier noch einmal zur Sicherheit
		player.set_process_input(false)
		get_tree().paused
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 7;
			change_menu_color()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
		elif Input.is_action_just_pressed("Menü"):
				# Eigentlich unnötiger Code, da ich unten den Menüpopup ja verstecke > immer not visible
				"""
				if get_node("Steuerungsmenü").visible:
					get_node("Steuerungsmenü").visible = false
				elif get_node("Hintergrundfarbpopup").visible:
					get_node("Hintergrundfarbpopup").visible = false
				"""
				# Resume game
				if not already_paused:
					get_tree().paused = false
				player.set_process_input(true)
				hide()
		# Hier wird definiert, was bei Mausklick auf die einzelnen Labels passiert.
		elif Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT):
			match selected_menu:
				0:
					pass
				1:  # Fortfahren
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				2:  # Steuerungsmenü wird geöffnet.
					get_node("Steuerungsmenü").popup()
					hide()
				3:  # Hintergrundfarbenmenü wird geöffnet.
					get_node("Hintergrundfarbpopup").popup()
					hide()
				4:  # Menü für die Bewegungsgeschwindigkeit wird geöffnet.
					get_node("Bewegungsgeschwindigkeitspopup").popup()
					hide()
				5:  # Neustart des Viewers
					get_tree().change_scene("res://Scenes/ModelViewer.tscn")
					get_tree().paused = false
				6:  # Viewer beenden
					get_tree().quit()

# Funktionen zum schließen der einzelnen Menüs.
func Steuermenu_schliessen():
	get_node("Steuerungsmenü").hide()
	popup()
func Hintergrundfarbpopup_schliessen():
	get_node("Hintergrundfarbpopup").hide()
	popup()
func Bewegungsgeschwindigkeitspopup_schliessen():
	get_node("Bewegungsgeschwindigkeitspopup").hide()
	popup()

# Wenn die Maus über dem Label mit dem entsprechenden Index hovert, wird die Farbe dieses Labels geändert.
func mouse_match_label0():
	selected_menu = 0
	change_menu_color()
func mouse_match_label1():
	selected_menu = 1
	change_menu_color()
func mouse_match_label2():
	selected_menu = 2
	change_menu_color()
func mouse_match_label3():
	selected_menu = 3
	change_menu_color()
func mouse_match_label4():
	selected_menu = 4
	change_menu_color()
func mouse_match_label5():
	selected_menu = 5
	change_menu_color()
func mouse_match_label6():
	selected_menu = 6
	change_menu_color()
