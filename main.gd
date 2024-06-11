extends Node2D

@onready var player: Sprite2D = $Player
var player_velocity := Vector2.ZERO

@onready var ally1boid: Boid = $Ally1Boid
@onready var ally2boid: Boid = $Ally2Boid
@onready var ally3boid: Boid = $Ally3Boid

var random_positions_for_each_ally := PackedVector2Array([])

func _ready() -> void:
	# generate positions for allies around player
	random_positions_for_each_ally.append(Vector2.UP.rotated(randf() * 2 * PI) * 200)
	random_positions_for_each_ally.append(Vector2.UP.rotated(randf() * 2 * PI) * 200)
	random_positions_for_each_ally.append(Vector2.UP.rotated(randf() * 2 * PI) * 200)
	
	# setup the entities each boid will manage and their obstacles
	ally1boid.entities.append($Ally1)
	ally1boid.obstacles.append($Ally2)
	ally1boid.obstacles.append($Ally3)
	ally1boid.obstacles.append($Player)
	
	ally2boid.entities.append($Ally2)
	ally2boid.obstacles.append($Ally1)
	ally2boid.obstacles.append($Ally3)
	ally2boid.obstacles.append($Player)
	
	ally3boid.entities.append($Ally3)
	ally3boid.obstacles.append($Ally2)
	ally3boid.obstacles.append($Ally1)
	ally3boid.obstacles.append($Player)	

func _physics_process(delta: float) -> void:
	# update player boid
	player.position += player_velocity * 150 * delta
	
	# update ally 1
	ally1boid.target = player.position + random_positions_for_each_ally[0]
	ally1boid.update_positions(delta)
	
	# update group 1 boid
	ally2boid.target = player.position + random_positions_for_each_ally[1]
	ally2boid.update_positions(delta)
	
	# update group 2 boid
	ally3boid.target = player.position + random_positions_for_each_ally[2]
	ally3boid.update_positions(delta)
	

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
