extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var life = 0.2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    life -= delta
    if life < 0:
        queue_free()
        return
    
    for enemy in get_tree().get_nodes_in_group("Enemy"):
        if overlaps_body(enemy):
            enemy.kill()
