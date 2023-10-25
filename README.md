# OberhausViewer-Godot

This viewer was created for a model seminar in the field of teacher education on the topic "Courtly Lifeforms" as part of the research project SKILL.de at the University of Passau. It has already been in use by students of this seminar to educate children on different medieval objects, their history, and names. However, it may be used in any other context where 3D models need to be displayed and contextualised through info boxes and additional 2D images.

Much of the interface and functionality of the model swapping mechanism is based on Ivolutio's ModelViewer (https://github.com/Ivolutio/ModelViewer-Godot). 
Upon this basis, it was greatly expanded in terms of control options and object contextualisation methods.

Guide for setting up and using the pre-exported OberhausViewer_1.00.exe:

Setup:
• Download and extract the zip file "OberhausViewer_1.00.zip."
• The included EXE file can be run without installation.
• Download the desired models and place them in the "Models" folder.
• If the EXE file is launched with no objects in the Models folder, a test cube will be loaded, and the following error message will be displayed:

# In the GitHub version of the viewer, no models are included.
# The following applies only to people who have access to the prepared models of the Oberhaus Museum.
# However, you may import your own models into Godot by copying the test cube scene and replacing the root node with your own model.
# For each model, a separate scene has to be created.
# For each model, there has to be an info box file (.tres) with the same name.
# Export the viewer without these scenes, and all the model scenes separately as PCK files to execute the program as intended.

Loading Models:
• Select and download the objects you need.
• Move the loaded PCK files to the designated "Models" folder in the program directory (OberhausViewer_1.00/Models).
• The models will be automatically recognized and loaded upon the next start of the OberhausViewer.

Important:
The folder structure within the "OberhausViewer_1.00" folder must not be altered! Otherwise, the viewer cannot load essential files such as models, info boxes, and images.
However, the entire folder can be moved on the PC as long as the internal structure remains intact.

Filling Info Boxes:
• In the "Infobox" folder, there are empty TRES files for each of our objects.
• These files can be edited with an editor, Notepad++, or a similar program (right-click > "Open with...").
• Each info box has five values: Label, Year, Word Explanation, and Text Example.
• Changing the text between the quotation marks after the equals sign will alter the value displayed in the info box.
• The formal structure of the TRES files should not be modified.
• Info boxes can also be edited directly within the viewer.
• You can enter the desired value into the respective input field (including copy and paste) and save it by pressing the Enter key.
• The associated TRES file will be automatically updated.
• TRES files can be easily shared and overwritten, for example, by uploading them to the LRZ server.

Integrating Images:
• You can place images in the "Illustrations" folder.
• The name of the image file must always match the file name of the corresponding object.
• The object name is displayed in the object viewer, usually in the bottom right corner.
• It is generally identical to the PCK file name, except for object sets (e.g., teeth).

Short-Cut List:
Esc = Open/Close Options Menu
Left Mouse Button + Mouse Movement = Rotate Object
Arrow Keys = Move Object in Space
Ctrl + r = Continuous Rotation (hold down)
Ctrl + h = Show/Hide Interface (=Screenshot Mode)
Ctrl + i = Show/Hide Info Box
Ctrl + p = Show/Hide Image
Ctrl + f = Full-Screen Mode (on/off)
Ctrl + o = Center Object (=soft reset)
Ctrl + a = Restart (hard reset)
+/- = Increase/Decrease Movement Speed
Ctrl + q = Change Control Mode
	Control Options:
    Mode 1 = The object rotates up and down by pushing or pulling the top (i. e. rotation up/down depends on mouse position (left/right) relative to the object center) (=Default Mode)
    Mode 2 = The object rotates with mouse movement without the need to press the left mouse button.
    Mode 3 = Object rotation up/down is independent of mouse position (recommended for round objects with no clear front and back, e.g., plates).
