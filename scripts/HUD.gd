extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  $Score.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func update_score(score):
  $Score.show()
  $Score.text = str(score, "m")

func update_difficulty(_score):
  pass

func show_game_over():
  $Score.hide()
