extends Node
class_name Database

var db: SQLite = SQLite.new()

func _ready() -> void:
	self.db.path = "res://phytopia.db"
	self.db.open_db()
	var table_name = "Players"
	var table_dict: Dictionary = {
		"id": {"data_type":"int", "primary_key": true, "auto_increment": true},
		"name": {"data_type":"text", "not_null": true},
		"planet": {"data_type":"text", "not_null": true},
		"duration": {"data_type":"int", "not_null": true}
	}
	
	db.query_with_bindings("SELECT name FROM sqlite_master WHERE type='table' AND name=?;", [table_name])
	if db.query_result.is_empty():
		db.create_table(table_name, table_dict)

func find_players_from_planet(planet: String):
	self.db.query_with_bindings(
		"SELECT * FROM Players WHERE planet=? ORDER BY duration ASC;",
		[planet]
	)
	return self.db.query_result

func find_player(player_name: String, planet_name: String):
	self.db.query_with_bindings(
		"SELECT * FROM Players WHERE name=? AND planet=? LIMIT 1;",
		[player_name, planet_name]
	)
	
	if db.query_result.size() == 1:
		return db.query_result[0]
	return null

func delete_player(player_name: String, planet_name: String):
	self.db.query_with_bindings(
		"DELETE FROM Players WHERE name=? AND planet=?;",
		[player_name, planet_name]
	)

func insert_player(player_name: String, planet_name: String, duration: float):
	self.db.insert_row("Players", {
		"name": player_name,
		"planet": planet_name,
		"duration": int(duration),
	})
