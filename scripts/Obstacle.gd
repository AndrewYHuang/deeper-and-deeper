extends KinematicBody2D

export var speed = 400

var stopped: bool = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  if !stopped: 
    var collision = move_and_collide(Vector2(0, -speed) * delta)
    if collision:
      if collision.collider.has_method("hit"): collision.collider.call("hit")

func _on_VisibilityNotifier2D_screen_exited():
  queue_free()

func spawn(spawn_position: Vector2):
  position = spawn_position

func stop():
  stopped = true

func _move_with_velocity(velocity):
  position += velocity