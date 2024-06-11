extends Node2D

@onready var player_boid: Boid = $PlayerStuff/PlayerBoid
@onready var player: Sprite2D = $PlayerStuff/Player
var player_velocity := Vector2.ZERO

@onready var enemy_boid1: Boid = $EnemyGroup1/EnemyBoid1
@onready var enemy_boid2: Boid = $EnemyGroup2/EnemyBoid2

func _ready() -> void:
	# setup the entities each boid will manage and their obstacles
	player_boid.entities.append($PlayerStuff/Ally1)
	player_boid.entities.append($PlayerStuff/Ally2)
	player_boid.obstacles.append($EnemyGroup1/Enemy1)
	player_boid.obstacles.append($EnemyGroup1/Enemy2)
	player_boid.obstacles.append($EnemyGroup2/Enemy1)
	player_boid.obstacles.append($EnemyGroup2/Enemy2)
	
	enemy_boid1.entities.append($EnemyGroup1/Enemy1)
	enemy_boid1.entities.append($EnemyGroup1/Enemy2)
	enemy_boid1.obstacles.append($PlayerStuff/Ally1)
	enemy_boid1.obstacles.append($PlayerStuff/Ally2)
	enemy_boid1.obstacles.append($EnemyGroup2/Enemy1)
	enemy_boid1.obstacles.append($EnemyGroup2/Enemy2)
	
	enemy_boid2.entities.append($EnemyGroup2/Enemy1)
	enemy_boid2.entities.append($EnemyGroup2/Enemy2)
	enemy_boid2.obstacles.append($PlayerStuff/Ally1)
	enemy_boid2.obstacles.append($PlayerStuff/Ally2)
	enemy_boid2.obstacles.append($EnemyGroup1/Enemy1)
	enemy_boid2.obstacles.append($EnemyGroup1/Enemy2)

func _physics_process(delta: float) -> void:
	# update player boid
	player.position += player_velocity * 150 * delta
	player_boid.target = player.position
	player_boid.update_positions(delta)
	
	# update group 1 boid
	enemy_boid1.target = player.position
	enemy_boid1.update_positions(delta)
	
	# update group 2 boid
	enemy_boid2.target = player.position
	enemy_boid2.update_positions(delta)
	

func _input(event: InputEvent) -> void:
	# handle player movement
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			player_velocity += Vector2(-1, 0)
		elif event.is_action_pressed("ui_right"):
			player_velocity += Vector2(1, 0)
		elif event.is_action_pressed("ui_up"):
			player_velocity += Vector2(0, -1)
		elif event.is_action_pressed("ui_down"):
			player_velocity += Vector2(0, 1)
		elif event.is_action_released("ui_left"):
			player_velocity -= Vector2(-1, 0)
		elif event.is_action_released("ui_right"):
			player_velocity -= Vector2(1, 0)
		elif event.is_action_released("ui_up"):
			player_velocity -= Vector2(0, -1)
		elif event.is_action_released("ui_down"):
			player_velocity -= Vector2(0, 1)
	elif event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index == MOUSE_BUTTON_LEFT:
			player.position = mouse_button.position
