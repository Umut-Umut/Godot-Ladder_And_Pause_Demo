extends KinematicBody2D

# Pause Ekrani Icin

# Once pause sahnesini olusturdum sonra ona bi script ekledim.
# Ardindan olusturdugum bu sahneyi proje ayarlarindan autoload a ekledim.




onready var global = get_tree().get_current_scene()
onready var animations = get_node("AnimatedSprite")

var gravity = -50

var vel = Vector2(0, 0)
var acc = 10
var max_speed = 100

var is_walk = false
var is_ladder = false

func _ready():
	pass


func _process(_delta):
	control()
	animation_manager()
	direction_manager()
	
	vel.y -= gravity
	
	vel = move_and_slide(vel)


var x_str
var y_str
func control():
	x_str = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	y_str = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	
	if x_str > 0:
		vel.x = min(vel.x+acc, max_speed)
	elif x_str < 0:
		vel.x = max(vel.x-acc, -max_speed)
	else: vel.x = lerp(vel.x, 0, 0.4)
	
	
	if is_ladder:
		if y_str < -0.9:
			vel.y = min(vel.y+acc, max_speed)
		elif y_str > 0.9:
			vel.y = max(vel.y-acc, -max_speed)
		else: vel.y = lerp(vel.y, 0, 0.4)
	
	
	if is_on_wall():
		if Input.is_action_just_pressed("ui_select"):
			vel.y -= 400


func animation_manager():
	if (y_str > 0.5 or y_str < -0.5) and is_ladder:
		animations.play("climp")
	elif x_str > 0.5 or x_str < -0.5:
		animations.play("walk")
	else: animations.play("idle")


func direction_manager():
	if x_str < -0.9:
		animations.flip_h = true
	elif x_str > 0.9:
		animations.flip_h = false


func _on_Area2D_body_entered(body):
	if body.collision_layer == 8:
		vel.y = 0
		gravity = 0
		is_ladder = true


func _on_Area2D_body_exited(body):
	if body.collision_layer == 8:
		gravity = -50
		is_ladder = false
