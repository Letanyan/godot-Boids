class_name Boid
extends Node2D

## nodes that will be updated by this Boid and its settings
@export var entities: Array[Node2D] = []

## nodes that only push the nodes in entities away
@export var obstacles: Array[Node2D] = []

## the target position for entity to gravitate towards
@export var target: Vector2 = Vector2.ZERO

# target_min_radius and target_max_radius create a disc around the target which 
# entities are allowed be in within being forced to move. In other words if an entities
# distance is greater than target_max_radius the entity is pushed closer to target. If the
# distance is lesser than target_min_radius the entity is pushed away from target. Setting
# target_min_radius equal to target_max_radius will force each entity to be on the circle edge
## the inner radius of the disc the entity is allowed to be towards the target 
@export_range(0, 1000, 10, "or_greater") var target_min_radius: float = 150.0
## the outer radius of the disc the entity must be within
@export_range(0, 1000, 10, "or_greater") var target_max_radius: float = 180.0

## The distance which each entity will try to find away from all other entities and obstacles
@export_range(0, 1000, 10, "or_greater") var seperation_radius: float = 150 

## The speed that each entity moves per second
@export_range(0, 200, 1, "or_greater") var movement_speed: float = 5
	
func update_positions(delta: float) -> void:
	# we are going to store each movement update in this array
	var movements := PackedVector2Array([])
	movements.resize(entities.size())
	movements.fill(Vector2.ZERO)
	
	for i in entities.size():
		var entity := entities[i]
		var movement := movements[i]
		
		# calculate the target position within the min/max radius disc 
		var distance_to_target := entity.position.distance_to(target)
		var target_within_radius: Vector2
		if distance_to_target < target_min_radius:
			target_within_radius = target.lerp(entity.position, target_min_radius / distance_to_target)
		elif distance_to_target > target_max_radius:
			target_within_radius = entity.position.lerp(target, target_max_radius / distance_to_target)
		else:
			continue
		
		# move entity towards target
		movement = (target_within_radius - entity.position).normalized()
			
		# move away from other entites
		for j in entities.size():
			if i == j:
				# ignore our own position
				continue
			var distance := entity.position.distance_to(entities[j].position)
			if distance < seperation_radius:
				movement += (entity.position - entities[j].position).normalized()
		# move away from obstacles
		for j in obstacles.size():
			var distance := entity.position.distance_to(obstacles[j].position)
			if distance < seperation_radius:
				movement += (entity.position - obstacles[j].position).normalized()
			
		# if the movement is small enough we ignore it
		movements[i] = movement.normalized()
		
	
	# update the positions for all entities after the above calculation are complete
	for i in entities.size():
		entities[i].position += movements[i] * delta * movement_speed
		
