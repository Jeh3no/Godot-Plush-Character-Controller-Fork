![preview.png](https://github.com/Jeh3no/Godot-Plush-Character-Controller-Fork/blob/main/addons/Arts/Images/preview.png)

# **General**


This asset provides a simple, fully commented, finite state machine based controller, camera, as well as a properties HUD

A test map is provided to test the controller.

The controller use a finite state machine, designed to be easely editable, allowing to easily add, remove and modify behaviours and actions.

Each state has his own script, allowing to easly filter and manage the communication between each state.

He is also very customizable, with a whole set of open variables for every state and for more general stuff. This is the same for the camera.

The asset is 100% written in GDScript.

He works perfectly on Godot 4.4, and should also works wells on the others 4.x versions (4.3, 4.2, 4.1, 4.0), but you will have to remove the uid files.

The video showcasing the asset features : https://youtu.be/xq3AqMtmM_4


# **Features**

 - Smooth moving
 - Ability to move on slopes and hills
 - Walking
 - Crouching (continious and once pressed input)
 - Running (continious and once pressed input)
 - Jumping (multiple jump system)
 - Jump buffering
 - Coyote jump/time
 - Air control (easely customizable thanks to curves)
 - Bunny hopping (+ auto bunny hop)
    
 - Camera tilt
 - Camera bob
 - Custom FOV
   
 - Reticle
 - Properties HUD

# **Purpose**


At start, i just wanted to rework my FPS controller template, make an alternate version of it, closer to the finite state machine approach.

But while i was working on it, i said to myself "why not share it with the community, when it's ready ?".

And so here we go !


# **How to use**


It's an asset, which means you can add it to an existing project without any issue.

Simply download it, add it to your project, get the files you want to use.

You will see for the player character script (and in the camera script) a keybinding variables group,

you need to create a input action in your project for each action, and then type the exact same name into the corresponding input action variable

(for example : name your move forward action "moveForward", and then type "moveForward" into the variable "moveForwardAction").

# **Requets**

- For any bug request, please write on down in the "issues" section.

- For any new feature request, please write it down in the "discussions" section.

- For any bug resolution/improvement commit, please write it down in the "pull requests" section.


# **Credits**



Godot Theme prototype Textures, by PiCode : https://godotengine.org/asset-library/asset/2480

Demo Audio: [Kenney](https://kenney.nl/assets/category:Audio?sort=update)
