extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


var speed = 48.0
var animation_time = 0.0

var inertia = Vector2()

var looking_direction = Vector2(0, 1)

var animation_lock = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    animation_time += delta
    
    animation_lock -= delta
    animation_lock = max(animation_lock, 0.0)
    
    var wish_direction = Vector2()
    
    if animation_lock == 0.0:
        if Input.is_action_pressed("ui_left"):
            $Sprite.frame = 1
            wish_direction.x += -1
            looking_direction = Vector2(-1, 0)
        if Input.is_action_pressed("ui_right"):
            $Sprite.frame = 2
            wish_direction.x += 1
            looking_direction = Vector2(1, 0)
        if Input.is_action_pressed("ui_up"):
            $Sprite.frame = 3
            wish_direction.y += -1
            looking_direction = Vector2(0, -1)
        if Input.is_action_pressed("ui_down"):
            $Sprite.frame = 0
            wish_direction.y += 1
            looking_direction = Vector2(0, 1)
    
        $Sprite.frame = $Sprite.frame % $Sprite.hframes
        if wish_direction != Vector2():
            if fmod(animation_time, 0.4) < 0.2:
                if fmod(animation_time, 0.8) < 0.4:
                    $Sprite.frame += $Sprite.hframes
                else:
                    $Sprite.frame += $Sprite.hframes*2
        else:
            animation_time = 0.0
    
    move_and_slide(wish_direction * speed + inertia)
    
    inertia = inertia.move_toward(Vector2(), delta * 1000.0)
    
    if inertia.length() > 16 and !$HurtBlip.playing:
        $HurtBlip.play()
    
    if Input.is_action_just_pressed("ui_accept"):
        var slash_scene = preload("res://Slash.tscn")
        var slash = slash_scene.instance()
        add_child(slash)
        slash.position = looking_direction * 12.0
        slash.rotation = Vector2().angle_to_point(looking_direction)
        
        $Sprite.frame = $Sprite.frame % $Sprite.hframes
        $Sprite.frame += $Sprite.hframes
        
        animation_lock = 0.2
        
        
