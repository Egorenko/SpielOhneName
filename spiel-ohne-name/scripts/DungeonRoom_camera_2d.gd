extends Camera2D

var Player: player1;
var cameraWorldSize: Vector2i;
var roomRect: Vector4;

func _ready() -> void:
	cameraWorldSize = get_camera_world_size();


func _process(_delta: float) -> void:
	Player = $"../player"
	
	position = Player.position;
	while(true):
		if (roomRect[2] + 16 < cameraWorldSize.x):
			position.x = roomRect[0] + roomRect[2] / 2 - 8;
			break;
		if (float(position.x - cameraWorldSize.x) / 2 <= roomRect[0] - 20):
			position.x = float(cameraWorldSize.x) / 2 + roomRect[0] - 20;
			break;
		if (float(position.x + cameraWorldSize.x) / 2 >= roomRect[0] - 4 + roomRect[2]):
			position.x = float(roomRect[0] - 4 + roomRect[2] - cameraWorldSize.x) / 2;
			break;
		break;
	while(true):
		if (roomRect[3] + 16 < cameraWorldSize.y):
			position.y = roomRect[1] + roomRect[3] / 2;
			break;
		if (float(position.y - cameraWorldSize.y) / 2 <= roomRect[1] - 20):
			position.y = float(cameraWorldSize.y) / 2 + roomRect[1] - 20;
			break;
		if (float(position.y + cameraWorldSize.y) / 2 >= roomRect[1] - 4 + roomRect[3]):
			position.y = float(roomRect[1] - 4 + roomRect[3] - cameraWorldSize.y) / 2;
			break;
		break;
	
	
func get_camera_world_size() -> Vector2i:
	return get_viewport_rect().size / zoom;
