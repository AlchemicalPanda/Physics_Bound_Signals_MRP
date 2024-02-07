extends Node2D


func _ready():
	#Connect to the signals for the physics frame and for the area and body entered to show the
	#passage of time and the observer overlapping the targets
	get_tree().physics_frame.connect(p_physics) #connect physics
	await get_tree().physics_frame
	$Observer.area_entered.connect(a_enter)
	$Observer.area_exited.connect(a_exit)
	$Observer.body_entered.connect(b_enter)
	$Observer.body_exited.connect(b_exit)
	
	print("
	The documentation of Area2d says to use signals for rapid processing
	of collision because the get_overlapping_area function fires only on physics
	frames.
	
	Signals appear to only occur on physics frames, which prevents
	acknowledgement of rapid movements as might occur if a npc is considering
	multiple possible moves and wants to determine the optimum move based on 
	collisions with other entities.
	
	This appears to either be a bug in the documentation, as signals are not
	the optimal way to track rapid changes in collision or a bug in the code
	
	
	This will now move an observing area2d twice, once with no delay between 
	arriving at the targets and returning to the origin, and once with a delay 
	before returning to the origin.  In the first example, all four signals
	(area entered and exited and body entered and exited) fire on the same
	physics frame, after the movement occurs.  In the second example, the enter
	and exit signals are on different frames because of an imposed delay.
	")
	
	#move observer to the marker location overlapping the targets
	print("Observer is at ", $Observer.global_position)
	$Observer.global_position = $Marker2D.global_position
	print("Observer is at ", $Observer.global_position)
	print("The signals should have fired by now")
	
	#move the observer back to the initial location
	$Observer.global_position = Vector2(0,0)
	print("Observer is at ", $Observer.global_position)
	print("
	Observer is back where it started and according to the documentation the
	signals should have already emited, but have not.  The entered and exited
	signals occur in the same physics frame which will happen after this 
	message when there is a delay
	")
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	print("
	This time we are going to let the physics frames catch up before we move
	the observer back to the origin.
	")
	#move to target
	print("Observer is at ", $Observer.global_position)
	$Observer.global_position = $Marker2D.global_position
	
	#wait for the physics frame to catch up
	print("Observer is at ", $Observer.global_position)
	await get_tree().physics_frame
	await get_tree().physics_frame
	print("Observer is at ", $Observer.global_position)
	print("Physics has caught up")
	
	#move back to start
	$Observer.global_position = Vector2(0,0)
	print("Observer is at ", $Observer.global_position)
	
	print("
	Done with movement.  As you can see, the entered signals occur
	but only because of the delay, and the exit signals have not yet occured, 
	but will after this message when there is a delay.
	")
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	
	#disconnect from signals
	get_tree().physics_frame.disconnect(p_physics)
	$Observer.area_entered.disconnect(a_enter)
	$Observer.area_exited.disconnect(a_exit)
	$Observer.body_entered.disconnect(b_enter)
	$Observer.body_exited.disconnect(b_exit)

func p_physics():
	print("Physics Frame")

func a_enter(area):
	print("The Observer has encountered an area target")

func a_exit(area):
	print("The Observer has left an area target")

func b_enter(body):
	print("The Observer has encountered a body target")

func b_exit(body):
	print("The Observer has left a body target")
