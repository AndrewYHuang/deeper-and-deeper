extends Node

export (PackedScene) var PatternSpawner

var score = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  randomize()

func new_game():
  score = 0
  get_tree().call_group("obstacles", "queue_free")
  get_tree().call_group("spawners", "queue_free")
  $Player.start($StartPosition.position)
  $StartTimer.start()
  Global.game_speed = 400.0

func _on_StartTimer_timeout():
  $ObstacleTimer.start()
  $ScoreTimer.start()


func _on_ObstacleTimer_timeout():
  var pattern = randi()
  var offset = randi() % 12
  var flip = randi() % 2 == 0

  var patternSpawner = PatternSpawner.instance()
  add_child(patternSpawner)

  patternSpawner.position = $PatternSpawnerPosition.position
  patternSpawner.spawn(pattern, offset, flip)
  patternSpawner.connect("pattern_complete", self, "_on_PatternSpawner_pattern_complete")

func _on_PatternSpawner_pattern_complete():
  $ObstacleTimer.start()
  

func _on_ScoreTimer_timeout():
  score += 1
  $HUD.update_score(score)

func game_over():
  $ScoreTimer.stop()
  $ObstacleTimer.stop()
  Global.game_speed = 0
  get_tree().call_group("obstacles", "stop")
  print_debug("GAME OVER")
  $HUD.show_game_over()
  $Menu.show_game_over(score)


