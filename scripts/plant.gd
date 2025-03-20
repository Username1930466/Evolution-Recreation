extends Area2D

@export var air = 0
@export var water = 0
@export var glucose = 30
@export var roots = 150
@export var adulthood = 15

var full_hunger_value : float
var hunger_value
var variation_multiplier
var starting_air
var starting_water
var starting_glucose
var reproduction_cooldown : float
var age = 0

func _ready() -> void:
	air = air * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	starting_air = air
	water = water * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	starting_water = water
	glucose = glucose * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	starting_glucose = glucose
	roots = roots * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	adulthood = adulthood * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	reproduction_cooldown = adulthood

func _process(delta: float) -> void:
	glucose -= delta
	air += 6 * delta
	age += delta
	if reproduction_cooldown > 0:
		reproduction_cooldown -= delta
	
	 # Drink water
	var nodes = get_tree().get_nodes_in_group("water")
	for node in nodes:
		if position.distance_to(node.position) <= roots:
			water += 6 * delta
			break
	
	if age < adulthood: # If still baby start small and get to normal size
		var size_mult = ((age / adulthood) + 0.5) / 0.75
		hunger_value = (age / adulthood) * full_hunger_value
		scale = Vector2(size_mult, size_mult)
	else:
		scale = Vector2(2, 2)
		hunger_value = full_hunger_value
	
	 # Running low on glucose
	if glucose < starting_glucose / 2:
		if water >= 6 and air >= 6: # If has enough air and water to make glucose
			var times_to_do
			if water > air:
				times_to_do = floor(air / 6)
			else:
				times_to_do = floor(water / 6)
			for i in times_to_do:
				water -= 6
				air -= 6
				glucose += 1
	
	 # Reproduction
	if glucose >= starting_glucose * 0.75 and reproduction_cooldown <= 0:
		sprout_a_child()
		reproduction_cooldown = 15
	
	 # Die of glucose deprivation
	if glucose <= 0:
		var dead_texture = load("res://art/DeadPlant.png")
		
		var stamp_sprite = Sprite2D.new()
		stamp_sprite.texture = dead_texture
		stamp_sprite.position = position
		stamp_sprite.scale = scale
		var shader = ShaderMaterial.new()
		shader.shader = load("res://scripts/shaders/wind_sway.gdshader")
		stamp_sprite.material = shader
		stamp_sprite.add_to_group("sways_in_wind")
		get_parent().update_plant_wind()
		
		get_parent().add_child(stamp_sprite)
		die()

func _on_body_entered(body) -> void:
	 # If touching anything, continue
	if body.name.find("Blob") != -1:
		 # If thing touched is blob, continue
		if body.hunger < body.stomach_capacity / 2:
			 # If the blob is hungry, give blob hunger and delete
			body.hunger += hunger_value
			die()

func eat(blob):
	 # If blob became hungry after it entered plants collision box, get eaten
	blob.hunger += hunger_value
	die()

func die():
	remove_from_group("food")
	remove_from_group("sways_in_wind")
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name.find("Pond") != -1:
		 # If spawned in pond, delete
		die()

func sprout_a_child():
	var child = load("res://scenes/plant.tscn").instantiate()
	child.air = starting_air
	child.water = starting_water
	child.glucose = starting_glucose
	child.roots = roots
	child.position = Vector2(position.x + randf_range(-40, 40), position.y + randf_range(-40, 40))
	child.variation_multiplier = variation_multiplier
	child.full_hunger_value = full_hunger_value
	get_parent().add_child(child)
