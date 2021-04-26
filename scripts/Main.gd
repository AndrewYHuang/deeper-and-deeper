extends Node

export (PackedScene) var PatternSpawner
export (Array, Array, Color) var ColorSets

var score = 0
var difficulty = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  randomize()

func new_game():
  score = 0
  difficulty = 0
  _update_colors(difficulty)
  get_tree().call_group("obstacles", "queue_free")
  get_tree().call_group("spawners", "queue_free")
  $Player.start($StartPosition.position)
  $StartTimer.start()
  $BackgroundMusic.play()
  Global.game_speed = 400.0

func _on_StartTimer_timeout():
  $HUD.update_score(score) 
  $HUD.update_difficulty(difficulty) 
  $ObstacleTimer.start()
  $ScoreTimer.start()
  $DifficultyTimer.start()



func _on_ObstacleTimer_timeout():
  var pattern = randi()
  var offset = randi() % 12
  var flip = randi() % 2 == 0

  var patternSpawner = PatternSpawner.instance()
  add_child(patternSpawner)

  patternSpawner.position = $PatternSpawnerPosition.position
  patternSpawner.spawn(pattern, offset, flip, difficulty)
  patternSpawner.connect("pattern_complete", self, "_on_PatternSpawner_pattern_complete")

func _on_PatternSpawner_pattern_complete():
  $ObstacleTimer.start()

func _on_ScoreTimer_timeout():
  score += 1
  $HUD.update_score(score)

func _on_DifficultyTimer_timeout():
  if difficulty < 5: difficulty += 1
  $HUD.update_difficulty(difficulty)
  _update_colors(difficulty)

func game_over():
  $ScoreTimer.stop()
  $ObstacleTimer.stop()
  $DifficultyTimer.stop()
  Global.game_speed = 0
  get_tree().call_group("obstacles", "stop")
  print_debug("GAME OVER")
  $BackgroundMusic.stop()
  $DeathSound.play()
  $HUD.show_game_over()
  $Menu.show_game_over(score)

func _update_colors(difficulty: int):
  var color_set= ColorSets[difficulty] 
  Global.background = color_set[0]
  Global.foreground = color_set[1]
  $Background.color = Global.background
  get_tree().call_group("obstacles", "set_color", Global.foreground)

