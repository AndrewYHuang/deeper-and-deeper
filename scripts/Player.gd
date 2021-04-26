extends Area2D

signal hit

export var fall_speed = 200
export var target_height_ratio = 0.35
export var squishinees = 0.2
export var rotation_rate = 40

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
  var direction = _direction_from_input()
  var ratio_to_target_height = (position.y / target_y_position)
  _set_trail(ratio_to_target_height)

  if movement_enabled:
    _squash_and_stretch_and_rotate(direction, ratio_to_target_height, delta)

func _physics_process(delta):
  var ratio_to_target_height = (position.y / target_y_position)
  var direction = _direction_from_input() if movement_enabled else 0

  var horizontal_speed = direction * Global.game_speed * 1
  var vertical_speed = _calculate_vertical_speed(ratio_to_target_height) if movement_enabled else 0

  _move_with_velocity(Vector2(horizontal_speed, vertical_speed) * delta)

  position.x = wrapf(position.x, 0, screen_size.x)


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

  $Polygon2D.rotation = visual_rotation 
  $Polygon2D.scale = scale
  $Hitbox.rotation = visual_rotation 
  $Hitbox.scale = scale

func _set_trail(ratio_to_target_height):
  $Trail.emitting = ratio_to_target_height > 0.4 && movement_enabled


func hit():
  emit_signal("hit")
  movement_enabled = false
  set_block_signals(true)

func _move_with_velocity(velocity):
  position += velocity
