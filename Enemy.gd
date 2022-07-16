extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var speed = 32.0
var animation_time = 0.0

var ai_state = "idle"
var ai_timer_max = 0.5
var ai_timer = ai_timer_max

func kill():
    var sound = $DeathSound
    remove_child(sound)
    get_parent().add_child(sound)
    sound.global_position = global_position
    sound.play()
    queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    for player in get_tree().get_nodes_in_group("Player"):
        if $HurtBox.overlaps_body(player):
            player.inertia = (player.global_position - global_position).normalized() * 128.0
    
    animation_time += delta
    ai_timer -= delta
    ai_timer = clamp(ai_timer, 0.0, ai_timer_max)
    
    if ai_timer == 0.0:
        if ai_state == "idle":
            var random_number = randi() % 4
            if random_number == 0:
                ai_state = "left"
            elif random_number == 1:
                ai_state = "right"
            elif random_number == 2:
                ai_state = "up"
            elif random_number == 3:
                ai_state = "down"
        else:
            ai_state = "idle"
        ai_timer = ai_timer_max
    
    var wish_direction = Vector2()
    if ai_state == "left":
        $Sprite.frame = 1
        wish_direction.x += -1
    if ai_state == "right":
        $Sprite.frame = 2
        wish_direction.x += 1
    if ai_state == "up":
        $Sprite.frame = 3
        wish_direction.y += -1
    if ai_state == "down":
        $Sprite.frame = 0
        wish_direction.y += 1
    
    $Sprite.frame = $Sprite.frame % $Sprite.hframes
    if fmod(animation_time, 0.4) < 0.2:
        $Sprite.frame += $Sprite.hframes
    
    move_and_slide(wish_direction * speed)
    pass
