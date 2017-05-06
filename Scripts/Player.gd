extends KinematicBody2D

#0 = not moving, 1 = right, -1 = left
var input_direction = 0
var direction = 0
var speed_x = 0
var speed_y = 0
var velocity = Vector2()

const ACCELERATION = 1000
const DECCELERATION = 2000
const MAX_SPEED = 600

const JUMP_FORCE = 800
const GRAVITY = 2000

func _ready():
	set_process(true)
	set_process_input(true)
	
	
func _input(event):
	if event.is_action_pressed("jump"):
		speed_y = -JUMP_FORCE
	pass
	
#Update
func _process(delta):
	
	if input_direction:
		direction = input_direction
	
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var stop_moving = !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right")
	
	if move_left:
		input_direction = -1
	elif move_right:
		input_direction = 1
	elif stop_moving:
		input_direction = 0

	if input_direction == -direction:
			speed_x /= 2
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECCELERATION * delta
	
	#So speed can't go over max_speed
	#Check first isn't below second, or above first
	#Because speed is always positive and then we multiply by direction it's fine to have the lower one be 0.
	#If we were only using speed as the direction and just setting it to negative for left then we'd set the second arg as -MAX_SPEED.
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	
	#Adds gravity
	speed_y += GRAVITY * delta
	
	velocity.y = speed_y * delta
	velocity.x = speed_x * delta * direction

	var movement_remainder = move(velocity)
	
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed_y = normal.slide(Vector2(0, speed_y)).y
		
		move(final_movement)
		
	pass