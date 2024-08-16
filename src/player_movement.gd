extends CharacterBody3D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _physics_process(delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity.x = input_direction.x
	velocity.z = input_direction.y
	velocity = velocity.normalized() * speed

	move_and_slide()
