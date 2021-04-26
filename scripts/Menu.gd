extends CanvasLayer

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  $Score.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _on_StartButton_pressed():
  $Overlay.hide()
  $StartButton.hide()
  $Title.hide()
  $Score.hide()
  emit_signal("start_game")

func show_game_over(score):
  $Overlay.show()
  $Title.show()
  $Score.show()
  $Score.text = str("You fell: ", score, "m")
  $StartButton.show()