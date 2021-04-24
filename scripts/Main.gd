extends Node

export (PackedScene) var Obstacle
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
  $Player.start($StartPosition.position)
  $StartTimer.start()

func _on_StartTimer_timeout():
  $ObstacleTimer.start()
  $ScoreTimer.start()


func _on_ObstacleTimer_timeout():
  $ObstacleSpawnPath/ObstacleSpawnLocation.offset = randi()

  var obstacle = Obstacle.instance()
  add_child(obstacle)
  obstacle.spawn($ObstacleSpawnPath/ObstacleSpawnLocation.position)


func _on_ScoreTimer_timeout():
  score += 1
  $HUD.update_score(score)

func game_over():
  $ScoreTimer.stop()
  $ObstacleTimer.stop()
  get_tree().call_group("obstacles", "stop")
  print_debug("GAME OVER")
  $Menu.show_game_over()
