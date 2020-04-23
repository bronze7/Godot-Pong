extends Node2D


var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)
var left_score = 0
var right_score = 0

const INITIAL_BALL_SPEED = 200
var ball_speed = INITIAL_BALL_SPEED
const pad_speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").texture.get_size()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_pos = get_node("ball").position
	var left_rect = Rect2(get_node("left").position - pad_size * 0.5, pad_size)
	var right_rect = Rect2(get_node("right").position - pad_size * 0.5, pad_size)
	#Ball movement
	ball_pos += direction * ball_speed * delta
	#change direction when hitting roof or floor
	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	#change direction after hitting paddle
	if((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf() * 2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
	#scoring
	if(ball_pos.x < 0):
		ball_pos = screen_size * 0.5
		ball_speed = INITIAL_BALL_SPEED
		right_score += 1
		direction = Vector2(1, 0)
	if(ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5
		ball_speed = INITIAL_BALL_SPEED
		left_score += 1
		direction = Vector2(-1, 0)
	get_node("left_score").text = str(left_score)
	get_node("right_score").text = str(right_score)
	get_node("ball").position = ball_pos
	#left paddle movement
	var left_pos = get_node("left").position
	
	if(left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -pad_speed * delta
	if(left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += pad_speed * delta
	get_node("left").position = left_pos
	
	var right_pos = get_node("right").position
	
	if(right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -pad_speed * delta
	if(right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += pad_speed * delta
	get_node("right").position = right_pos
	
	#win condition
	if(left_score == 5 and left_score > right_score):
		get_node("center").text = "Player One Wins!!"
		set_process(false)
	if(right_score == 5 and right_score > left_score):
		get_node("center").text = "Player Two Wins!!\nPress Space to Restart"
		set_process(false)
	if(is_processing() == false and Input.is_key_pressed(KEY_SPACE)):
		left_score = 0
		right_score = 0
		set_process(true)
func _input(event: InputEvent) -> void:
	if(event is InputEventKey and event.is_pressed()):
		if(Input.is_key_pressed(KEY_SPACE)):
			left_score = 0
			right_score = 0
			get_node("center").text = " "
			set_process(true)
