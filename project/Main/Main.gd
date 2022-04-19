extends Node2D

const PERCENT_CHANCE_OF_ENEMY := 2.0
const VISUAL_BORDER_WIDTH := 10
const BOARD_SIZE := 100
const EMPTY_TILES := {
	4:"plain",
	5:"plain",
	6:"plain",
	7:"decorated",
	8:"decorated",
	9:"plain",
	10:"plain",
	11:"decorated",
	12:"decorated",
}
const PLAIN_TILE_MULTIPLIER := 20
const WALL_TILE := 13
const ENEMY_DATA := [
	{"path":"res://Enemy/MeleeEnemy.tscn", "ratio":2},
	{"path":"res://Enemy/RangedEnemy.tscn", "ratio":2},
	{"path":"res://Enemy/TurretEnemy.tscn", "ratio":2},
]

var _potential_player_positions = [] as PoolVector2Array
var _enemy_path_list := []
var _empty_tiles := []

onready var _tilemap = $TileMap as TileMap
onready var _enemy_container = $EnemyContainer as Node2D
onready var _player = $Player as Player


func _ready()->void:
	for dataset in ENEMY_DATA:
		for i in dataset["ratio"]:
			_enemy_path_list.append(dataset["path"])
	
	for tile in EMPTY_TILES:
		if EMPTY_TILES[tile] == "plain":
			for x in PLAIN_TILE_MULTIPLIER:
				_empty_tiles.append(tile)
		_empty_tiles.append(tile)
	
	randomize()
	_generate_map()


func _set_cell(x:int, y:int, noise:OpenSimplexNoise)->void:
	var value := noise.get_noise_2d(x, y)
	if value > 0.2 or value < -0.4:
		_tilemap.set_cell(x, y, WALL_TILE)
	else:
		_tilemap.set_cell(x, y, _get_empty_tile())
		if x > 1 and y > 1 and x < BOARD_SIZE and y < BOARD_SIZE:
			if randi() % 100 < PERCENT_CHANCE_OF_ENEMY:
				var enemy = load(_enemy_path_list[randi() % _enemy_path_list.size()]).instance()
				enemy.position = _tilemap.map_to_world(Vector2(x, y)) + Vector2(16, 16)
				_enemy_container.add_child(enemy)
			else:
				_potential_player_positions.append(Vector2(x, y))


func _get_empty_tile()->int:
	return _empty_tiles[randi()%_empty_tiles.size()]


func _finish_map()->void:
	pass


func _generate_map()->void:
	# remove any enemies already on board
	for enemy in _enemy_container.get_children():
		enemy.queue_free()
	
	# create noise
	var noise := OpenSimplexNoise.new()
	noise.octaves = 2
	noise.period = 10
	noise.seed = randi()
	
	# fill board
	for x in BOARD_SIZE + VISUAL_BORDER_WIDTH * 2:
		var modified_x = x - VISUAL_BORDER_WIDTH as int
		for y in BOARD_SIZE + VISUAL_BORDER_WIDTH * 2:
			var modified_y = y - VISUAL_BORDER_WIDTH as int
			_set_cell(modified_x, modified_y, noise)
	
	# create border
	for x in range(0, BOARD_SIZE + 1):
		_tilemap.set_cell(x, 0, WALL_TILE)
		_tilemap.set_cell(x, BOARD_SIZE, WALL_TILE)
		_tilemap.set_cell(0, x, WALL_TILE)
		_tilemap.set_cell(BOARD_SIZE, x, WALL_TILE)
	
	# set player position
	var _player_map_position = _potential_player_positions[randi()%_potential_player_positions.size()]
	_player.position = _tilemap.map_to_world(_player_map_position) + Vector2(16, 16)
	_potential_player_positions = []
	
	_tilemap.update_bitmask_region()


func _on_Player_respawn()->void:
	_generate_map()
