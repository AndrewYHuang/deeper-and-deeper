extends Area2D

export var speed = 400
var screen_size

var stopped: bool = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  if !stopped: 
    _move_with_velocity(Vector2(0, -speed) * delta)

func _on_VisibilityNotifier2D_screen_exited():
  queue_free()

func offset(offset):
  position.x = wrapf(position.x + offset, 0, screen_size.x)

func stop():
  stopped = true

func _move_with_velocity(velocity):
  position += velocity

func _on_Obstacle_area_entered(body):
  if body.has_method("hit"): body.hit()