extends Area2D

signal hit

export var speed = 400
export var fall_speed = 200
export var target_height_ratio = 0.55
export var squishinees = 0.2
export var rotation_rate = 20

var screen_size
var target_y_position
var visual_rotation = 0

func start(start_position):
  show()
  position = start_position
  visual_rotation = 0
  $CollisionShape2D.disabled = false

func _ready():
  screen_size = get_viewport_rect().size
  target_y_position = screen_size.y * target_height_ratio

func _process(delta):
  var direction = _direction_from_input()
  var ratio_to_target_height = (position.y / target_y_position)

  var horizontal_speed = direction * speed
  var vertical_speed = _calculate_vertical_speed(ratio_to_target_height)

  _move_with_velocity(Vector2(horizontal_speed, vertical_speed) * delta)
  _squash_and_stretch_and_rotate(direction, ratio_to_target_height, delta)

func _direction_from_input() -> int:
  var direction: int = 0
  if Input.is_action_pressed("ui_right"):
    direction += 1
  if Input.is_action_pressed("ui_left"):
    direction -= 1
  return direction

func _calculate_vertical_speed(ratio_to_target_height):
  return (1 - ratio_to_target_height * ratio_to_target_height) * fall_speed

func _squash_and_stretch_and_rotate(direction, ratio_to_target_height, delta):
  visual_rotation = lerp(visual_rotation, tanh(-direction) * PI/4, rotation_rate * delta)
  var scale = Vector2(1 - squishinees * ratio_to_target_height, 1 + squishinees * ratio_to_target_height)
  var t = Transform2D().rotated(visual_rotation).scaled(scale)

  $Polygon2D.transform = t

func _move_with_velocity(velocity):
  position += velocity
  position.x = clamp(position.x, 0, screen_size.x)
  position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_area_entered(area):
  emit_signal("hit")
  $CollisionShape2D.set_deferred("disabled", true)
