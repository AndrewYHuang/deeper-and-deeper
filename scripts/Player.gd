extends KinematicBody2D

signal hit

export var speed = 400
export var fall_speed = 200
export var target_height_ratio = 0.55
export var squishinees = 0.2
export var rotation_rate = 20

var screen_size
var target_y_position
var visual_rotation = 0
var movement_enabled = true

func start(start_position):
  show()
  position = start_position
  visual_rotation = 0
  movement_enabled = true
  set_block_signals(false)

func _ready():
  hide()
  screen_size = get_viewport_rect().size
  target_y_position = screen_size.y * target_height_ratio

func _process(delta):
  if movement_enabled:
    var direction = _direction_from_input()
    var ratio_to_target_height = (position.y / target_y_position)
    _squash_and_stretch_and_rotate(direction, ratio_to_target_height, delta)

func _physics_process(delta):
  var ratio_to_target_height = (position.y / target_y_position)
  var direction = _direction_from_input() if movement_enabled else 0

  var horizontal_speed = direction * speed
  var vertical_speed = _calculate_vertical_speed(ratio_to_target_height) if movement_enabled else 0

  var _collision = move_and_collide(Vector2(horizontal_speed, vertical_speed) * delta, false)

  position.x = clamp(position.x, 0, screen_size.x)


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

  self.rotation = visual_rotation 
  self.scale = scale

func hit():
  emit_signal("hit")
  movement_enabled = false
  set_block_signals(true)
