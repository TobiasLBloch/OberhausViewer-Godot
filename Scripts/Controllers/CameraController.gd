extends Spatial

# Definition der Kameravariable und einiger Steuerungsvariablen
onready var camera = get_node("Camera")
onready var rotateSpeed = .5
onready var rotateSmoothing = 10
onready var rotateLimits = [-89, 89]
onready var zoomSpeed = 6
onready var zoomSmoothing = 10
onready var zoomLimits = [5, 70]

#Legt Neigungswinkel beim Start an
var yaw = 0
var pitch = 0
var zoom = 50
var direction = Vector3.FORWARD
var z
var GeschwindigkeitsFaktor = 0.0001
var GeschwindigkeitsGaenge = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var GangIndex = 2

# Variablen für verschiedene Funktionen als Boolean gespeichert; bei Start sind alle false, erst bei Input werden die angesrochenen true.
var doRotate
var doMoveUP = false
var doMoveDOWN = false
var doMoveLEFT = false
var doMoveRIGHT = false
var doZoomPlus = false
var doZoomMinus = false
var Rotationssteuerung = 1

func _physics_process(delta):
	var Bewegungsgeschwindigkeit = (110-5*$modelContainer.transform.origin.z)*GeschwindigkeitsFaktor
	# _physics_process(delta) refresht regelmäßig.
	# Bei Tastatur-Input wird die jeweilige Koordinate um 0.01 erhöht/gesenkt.
	# Bewegt wird nur der modelContainer, da Vector3() den Node model sonst relativ zur Rotation bewegen würde.
	# D. h. wäre das Modell leicht schräg, würde es sich bei einem Tastentruck auf links auch leicht nach links hinten bewegen.
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("Controller_UP"):
		$modelContainer.translate(Vector3(0,Bewegungsgeschwindigkeit,0))
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("Controller_DOWN"):
		$modelContainer.translate(Vector3(0,-1*Bewegungsgeschwindigkeit,0))
		#print($modelContainer.transform.origin.y)
	if Input.is_action_pressed("left") or Input.is_action_pressed("Controller_LEFT"):
		$modelContainer.translate(Vector3(-1*Bewegungsgeschwindigkeit,0,0))
	if Input.is_action_pressed("right") or Input.is_action_pressed("Controller_RIGHT"):
		$modelContainer.translate(Vector3(Bewegungsgeschwindigkeit,0,0))
	
	#ButtonSteuerung
	if doMoveUP == true:
		$modelContainer.translate(Vector3(0,Bewegungsgeschwindigkeit,0))
	if doMoveDOWN == true:
		$modelContainer.translate(Vector3(0,-1*Bewegungsgeschwindigkeit,0))
	if doMoveLEFT == true:
		$modelContainer.translate(Vector3(-1*Bewegungsgeschwindigkeit,0,0))
	if doMoveRIGHT == true:
		$modelContainer.translate(Vector3(Bewegungsgeschwindigkeit,0,0))
	if doZoomPlus == true:
		# Bewegt Objekt entlang der z-Achse
		if $modelContainer.transform.origin.z <= 10.1:
			$modelContainer.translate(Vector3(0,0,0.1))
		else:
			pass
	if doZoomMinus == true:
		if $modelContainer.transform.origin.z >= -19:
			$modelContainer.translate(Vector3(0,0,-0.1))
		else:
			pass
		
	if Input.is_action_pressed("rotate"):
		# Rotiert das eig. Modell an der Y-Achse
		get_node("modelContainer/model").rotation.y -= 0.01
				
	# Sicherstellen, dass Rotation nicht < 360 und kleiner -180 wird
	if get_node("modelContainer/model").rotation_degrees.y >= 360:
		get_node("modelContainer/model").rotation_degrees.y = 0
	elif get_node("modelContainer/model").rotation_degrees.y <= -180:
		get_node("modelContainer/model").rotation_degrees.y = 180
	else:
		pass
	
	# Setzt fest welche Rotationssteuerung verwendet wird, die einfache oder die ausgefeilte.
	if Input.is_action_just_pressed("Rotationssteuerung"):
		if Rotationssteuerung == 3:
			Rotationssteuerung = 1
		else:
			Rotationssteuerung += 1
		#print(Rotationssteuerung)
	else:
		pass
	
	# Gamepad-Steuerung:
	var deadZone = 0.01
	# Die Rotationswinkel auf der x- und y-Achse werden mit der Joystickbewegung erhöht bzw. gesenkt.
	var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
	var yAxis = Input.get_joy_axis(0,JOY_AXIS_3)
	if abs(xAxis) > deadZone or abs(yAxis) > deadZone: 
		if Input.is_action_pressed("ControllerRechtsStickLEFT"):
			get_node("modelContainer/model").rotation_degrees.y += xAxis*10
			#print (xAxis)
		elif Input.is_action_pressed("ControllerRechtsStickRIGHT"):
			get_node("modelContainer/model").rotation_degrees.y -= xAxis*10
			#print(xAxis)
		elif Input.is_action_pressed("ControllerRechtsStickUP") or Input.is_action_pressed("ControllerRechtsStickDOWN"):
			get_node("modelContainer/model").rotation_degrees.x += yAxis

# Refresht den Neigungswinkel mit der Framerate (1x pro Frame).
func _process(delta):
	# lerp() macht die Bewegung smooth?
	var targetPitch = lerp(rotation_degrees.x, pitch, delta * rotateSmoothing)
	var targetYaw = lerp(rotation_degrees.y, yaw, delta * rotateSmoothing)
	var targetZoom = lerp(camera.fov, zoom, delta * zoomSmoothing)
	
	# Die Neigungswinkel werden festgelegt
	rotation_degrees = Vector3(targetPitch, targetYaw, 0)
	camera.fov = targetZoom
	
	if Input.is_action_just_pressed("Vollbild"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	pass

# Funktion für die Bewegungsgeschwindigkeitsoption im Optionsmenü
func Gangschaltung(extra_arg_0):
	GangIndex = extra_arg_0
	GeschwindigkeitsFaktor = 0.0001 * GeschwindigkeitsGaenge[GangIndex]
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			# setzt doRotate auf true, wenn BUTTON_LEFT == pressed?
			if Rotationssteuerung != 2:
				doRotate = event.pressed

		if event.button_index == BUTTON_WHEEL_DOWN:
			# Bewegt Kamera
			
			# Bewegt Objekt entlang der z-Achse
			if $modelContainer.transform.origin.z >= -19:
				$modelContainer.translate(Vector3(0,0,-0.6))
			else:
				pass
		if event.button_index == BUTTON_WHEEL_UP:
			#zoom = clamp(zoom - zoomSpeed, zoomLimits[0], zoomLimits[1])
			if $modelContainer.transform.origin.z <= 10.1:
				$modelContainer.translate(Vector3(0,0,0.6))
			else:
				pass
		
	if doRotate or Rotationssteuerung == 2:
		# Wenn doRotate == true [== BUTTON_LEFT pressed], dann ausführen
		if event is InputEventMouseMotion:
			if Rotationssteuerung == 3:
				# Einfache Rotation ohne Rücksicht auf Position des Objekts
				# Die Rotationswinkel auf der x- und y-Achse werden mit der relativen Mauspositionsveränderung erhöht bzw. gesenkt
				get_node("modelContainer/model").rotation_degrees.y += event.relative.x/5
				get_node("modelContainer/model").rotation_degrees.x += event.relative.y/5
			
			else:
				# Ausgefeiltere Rotation unter Berücksichtigung der Objektposition
				# Gibt Größe des Bildschirms an (=Fensterauflösung)
				var ScreenSize = get_viewport().size
				# Gibt die Hälfte der Bildschirmbreite an
				var ScreenCenter = ScreenSize.x/2
				var MousePos = event.position
				var ObjPos = get_node("modelContainer").global_transform.origin
				# Trigonomische Berechnung der Position des Objekts projiziert über den Kamerawinkel auf die Gesamtgröße des Bildschirms
				# 10.77 ist der Abstand der Kamera zur Startposition des Objekts (= Mittelpunkt des 3D-Raumes)
				var Ankath = 10.77-ObjPos.z
				var Gegkath = ObjPos.x
				# Berechnet den (halben) Kamerawinkel (siehe Notizbuch 3 S. 187)
				var Alpha = rad2deg(atan(Gegkath/Ankath))
				# Berechnet mit obigem Winkel auf welche Position sich die Hypotenuse von der Kamera aus 
				# > über den berechneten Kamerawinkel bis zum hinteren Screen (von dem aus die Mausposition angegeben wird)
				# erstrecken würde
				# 820 ist der von mir berechnete (fiktive?) Abstand von der Kamera zum hinteren Bildschirmrand
				var ObjPosRelToFullScreen = tan(deg2rad(Alpha))*820
				
				# Handelt die Rotation seitwärts
				get_node("modelContainer/model").rotation_degrees.y += event.relative.x/5
				# Handelt die Rotation nach oben und unten
				if get_node("modelContainer/model").rotation_degrees.y > 15 and get_node("modelContainer/model").rotation_degrees.y < 175:
					if MousePos.x < ScreenCenter+ObjPosRelToFullScreen:
						get_node("modelContainer/model").rotation_degrees.x -= event.relative.y/5
					else:
						get_node("modelContainer/model").rotation_degrees.x += event.relative.y/5
				elif get_node("modelContainer/model").rotation_degrees.y < -20 or get_node("modelContainer/model").rotation_degrees.y > 195:
					if MousePos.x > ScreenCenter+ObjPosRelToFullScreen:
						get_node("modelContainer/model").rotation_degrees.x -= event.relative.y/5
					else:
						get_node("modelContainer/model").rotation_degrees.x += event.relative.y/5
				elif get_node("modelContainer/model").rotation_degrees.y >= 175 and get_node("modelContainer/model").rotation_degrees.y <= 195:
					get_node("modelContainer/model").rotation_degrees.x -= event.relative.y/5
				else:
					get_node("modelContainer/model").rotation_degrees.x += event.relative.y/5
				
				#Zum Prüfen, ob die Mausposition im Verhältnis zum Objekt richtig erkannt wird
				"""
				if MousePos.x > ScreenCenter+ObjPosRelToFullScreen:
					print("Ich bin rechts des Objekts "+str(MousePos.x-ScreenCenter))
				else:
					print("Ich bin links des Objekts "+str(MousePos.x-ScreenCenter))
				"""
			
	if event is InputEventKey:
		if event.scancode == KEY_KP_ADD:
			if GangIndex == 8:
				pass
			else:
				GangIndex += 1
		elif event.scancode == KEY_KP_SUBTRACT:
			if GangIndex == 0:
				pass
			else:
				GangIndex -= 1
		else:
			pass
		#print(GangIndex)
		GeschwindigkeitsFaktor = 0.0001 * GeschwindigkeitsGaenge[GangIndex]
	else:
		pass
		
	if Input.is_action_pressed("Zoom+"):
		doZoomPlus = true
	else:
		doZoomPlus = false
		
	if Input.is_action_pressed("Zoom-"):
		doZoomMinus = true
	else:
		doZoomMinus = false
		
	if Input.is_action_just_pressed("ResetObjekt"):
		resetObject()
	if Input.is_action_just_pressed("ResetAll"):
		reset()

#Steuerbuttonfunktionen
func moveUP(wert):
	doMoveUP = wert
	
func moveDOWN(wert):
	doMoveDOWN = wert

func moveLEFT(wert):
	doMoveLEFT = wert

func moveRIGHT(wert):
	doMoveRIGHT = wert

func zoomButtonPlus(wert):
	doZoomPlus = wert
	
func zoomButtonMinus(wert):
	doZoomMinus = wert

func resetObject():
	doMoveUP = false
	doMoveDOWN = false
	doMoveLEFT = false
	doMoveRIGHT = false
	doZoomPlus = false
	doZoomMinus = false
	Rotationssteuerung = 1
	GangIndex = 0
	get_node("modelContainer/model").rotation_degrees.x = 0
	get_node("modelContainer/model").rotation_degrees.y = 0
	$modelContainer.transform.origin = Vector3(0,0,0)

func reset():
	get_tree().reload_current_scene()
