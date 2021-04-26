extends Node2D

export (Array, Array, PackedScene) var PatternSets

signal pattern_complete

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func spawn(selected_pattern: int, offset: int, flip: bool, difficulty: int):
  var pattern_set = PatternSets[difficulty]
  var pattern = pattern_set[selected_pattern % pattern_set.size()].instance()
  add_child(pattern)
  pattern.offset(offset*32)
  if flip: pattern.flip()

  $EndOfPattern.position = pattern.get_node("EndOfPattern").position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  $EndOfPattern.position.y -= Global.game_speed * delta

func _on_EndOfPattern_screen_entered():
  print_debug("I'm almost done")
  emit_signal("pattern_complete")

func _on_EndOfPattern_screen_exited():
  print_debug("I'm done!")
  queue_free()
