A simple and complete third person controller asset, made in Godot 4.

![preview.png](https://github.com/Jeh3no/Godot-State-Machine-Third-Person-Controller/blob/main/addons/Arts/Images/preview.png?raw=true)


# **General**


This asset is a heavely modified fork of Gtibo's Godot-Plush-Character project (https://github.com/gtibo/Godot-Plush-Character).

It provides a simple, fully commented, finite state machine based controller, camera, as well as a properties HUD.

A test map is provided to test the controller.

A cute 3D character model made by Gtibo is also provided, fully animated (he use an animation tree powered by a state machine as well), plus movement sounds and particles effects.

The controller use a finite state machine, designed to be easely editable, allowing to easily add, remove and modify behaviours and actions.

Each state has his own script, allowing to easly filter and manage the communication between each state.

He is also very customizable, with a whole set of open variables for every state and for more general stuff. This is the same for the camera.

The asset is 100% written in GDScript, with the snake case convention.

He works perfectly on Godot 4.4, and should also works wells on the others 4.x versions (4.3, 4.2, 4.1, 4.0), but you will have to remove the uid files.


# **Features**


 - Smooth moving
 - Ability to move on slopes and hills
 - Walking
 - Running (continious and once pressed input)
 - Jumping (with multiple jump system)
 - Auto jump
 - Jump cutting
 - Jump buffering
 - Coyote jump/time
 - Air control (easely customizable thanks to curves)
 - Ragdoll
   
 - Default/Free camera
 - Aim/Shooter/Above shoulder camera (with left and right sides)
 - Camera pan
 - Camera zoom

 - Model orientation (camera independant, or camera follower)
   
 - Properties/Debug HUD


# **Purpose**


I saw the Godot plush project bu Gtibo about 1,5 weeks, and i told to myself "hey, that would be a great start point for a third person controller !"

And so, here we go !


# **How to use**


It's an asset, which means you can add it to an existing project without any issue.

Simply download it, add it to your project, get the files you want to use.

You will see for the player character script (and in the camera script) a keybinding variables group,

you need to create a input action in your project for each action, and then type the exact same name into the corresponding input action variable

(for example : name your move forward action "move_forward", and then type "move_forward" into the variable "move_forward_action").


# **Requets**

- For any bug request, please write on down in the "issues" section.

- For any new feature request, please write it down in the "discussions" section.

- For any bug resolution/improvement commit, please write it down in the "pull requests" section.


# **Credits**


Demo Audio: [Kenney](https://kenney.nl/assets/category:Audio?sort=update)
