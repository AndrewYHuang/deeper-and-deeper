extends KinematicBody2D

signal hit

export var speed = 400
export var fall_speed = 200
export var target_height_ratio = 0.55
export var squishinees = 0.2

var screen_size
var target_y_position
var ratio_to_target_height = 0
var direction 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start(start_position):
  show()
  position = start_position
  ratio_to_target_height = 0
  $CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
  screen_size = get_viewport_rect().size
  target_y_position = screen_size.y * target_height_ratio
  pass # Replace with function body.

func _process(delta):
  position.x = clamp(position.x, 0, screen_size.x)
  position.y = clamp(position.y, 0, screen_size.y)
  _squash_and_stretch_and_rotate()

func _physics_process(delta):
  _update_direction_from_input()
  ratio_to_target_height = (position.y / target_y_position)

  var horizontal_velocity = direction * speed * delta
  var vertical_velocity = _calculate_vertical_speed() * delta

  var collision = move_and_collide(Vector2(horizontal_velocity, vertical_velocity))

  if collision: 
    emit_signal("hit")
    $CollisionShape2D.set_deferred("disabled", true)

func _update_direction_from_input():
  direction = 0
  if Input.is_action_pressed("ui_right"):
    direction += 1
  if Input.is_action_pressed("ui_left"):
    direction -= 1

func _calculate_vertical_speed():
  return (1 - ratio_to_target_height * ratio_to_target_height) * fall_speed

func _squash_and_stretch_and_rotate():
  var t = Transform2D().rotated(tanh(direction) * PI/2).scaled(Vector2(1 - squishinees * ratio_to_target_height, 1 + squishinees * ratio_to_target_height))

  $Polygon2D.transform = t
