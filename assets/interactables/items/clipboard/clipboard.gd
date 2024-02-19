class_name Clipboard
extends Node3D

@export var item_name: String = "clipboard"

@export var content_viewport: SubViewport
@export var paper_mesh : MeshInstance3D
@export var paper_area : Area3D

var quad_mesh_size
var is_active: bool = false
var is_mouse_held: bool = false
var is_mouse_inside: bool = false
var last_mouse_position3D = null
var last_mouse_position2D = null


func _ready() -> void:
	# Set up texturing so engine doesn't complain at runtime
	var paper_texture: ViewportTexture = content_viewport.get_texture()
	var paper_material = paper_mesh.material_override
	paper_material = paper_material as StandardMaterial3D
	if paper_material:
		paper_material.albedo_texture = paper_texture
	
	paper_area.mouse_entered.connect(_mouse_entered_area)	


func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return
	var is_mouse_event = false
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		is_mouse_event = true
		if !is_mouse_inside:
			var camera: Camera3D = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(event.position)
			var dist = 4.0
			var to = from + camera.project_ray_normal(event.position) * dist
			var query := PhysicsRayQueryParameters3D.create(from, to, paper_area.collision_layer)
			query.collide_with_areas = true
			var result = get_world_3d().direct_space_state.intersect_ray(query)
			if result.size() > 0:
				is_mouse_inside = true
	if is_mouse_event and (is_mouse_inside or is_mouse_held):
		handle_mouse(event)
	elif !is_mouse_event:
		content_viewport.push_input(event)


func handle_mouse(event: InputEvent) -> void:
	quad_mesh_size = Vector2(0.23, 0.32)
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed
	
	var mouse_position3D = find_mouse(event.position)
	
	is_mouse_inside = !is_nan(mouse_position3D.x)
	if is_mouse_inside:
		mouse_position3D = paper_area.global_transform.affine_inverse() * mouse_position3D
		last_mouse_position3D = mouse_position3D
	else:
		mouse_position3D = last_mouse_position3D
		if mouse_position3D == null:
			mouse_position3D = Vector3.ZERO
	
	var mouse_position2D = Vector2(mouse_position3D.x, mouse_position3D.z)
	
	mouse_position2D.x += quad_mesh_size.x / 2
	mouse_position2D.y += quad_mesh_size.y / 2
	
	mouse_position2D.x = mouse_position2D.x / quad_mesh_size.x
	mouse_position2D.y = mouse_position2D.y / quad_mesh_size.y

	mouse_position2D.x = mouse_position2D.x * content_viewport.size.x
	mouse_position2D.y = mouse_position2D.y * content_viewport.size.y

	event.position = mouse_position2D
	event.global_position = mouse_position2D
	
	if event is InputEventMouseMotion:
		if last_mouse_position2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = mouse_position2D - last_mouse_position2D
	# Update last_mouse_pos2D with the position we just calculated.
	last_mouse_position2D = mouse_position2D

	# Finally, send the processed input event to the viewport.
	content_viewport.push_input(event)


func find_mouse(event_position: Vector2) -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(event_position)
	var dist = find_further_distance_to(camera.transform.origin)
	var to = from + camera.project_ray_normal(event_position) * dist
	
	var query := PhysicsRayQueryParameters3D.create(from, to, paper_area.collision_layer)
	query.collide_with_areas = true
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.size() > 0:
		return result.position
	return Vector3(NAN, NAN, NAN)


func find_further_distance_to(origin_point: Vector3) -> float:
	var edges: Array[Vector3] = []
	edges.append(paper_area.to_global(Vector3(quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(paper_area.to_global(Vector3(quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))
	edges.append(paper_area.to_global(Vector3(-quad_mesh_size.x / 2, quad_mesh_size.y / 2, 0)))
	edges.append(paper_area.to_global(Vector3(-quad_mesh_size.x / 2, -quad_mesh_size.y / 2, 0)))
	
	var far_dist: float = 0.0
	var temp_dist: float
	for edge in edges:
		temp_dist = origin_point.distance_to(edge)
		if temp_dist > far_dist:
			far_dist = temp_dist

	return far_dist


func set_active(value: bool) -> void:
	is_active = value


func _mouse_entered_area() -> void:
	is_mouse_inside = true
