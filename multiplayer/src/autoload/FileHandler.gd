extends Node
class_name FielHandler

# Read config file
func read_json_file_as_dictionary(path:String) -> Dictionary:
	var file = File.new()
	file.open(path, file.READ)
	var result = JSON.parse(file.get_as_text()).get_result()
	file.close()
	return result

# Create or read the unique id of the game
func read_game_hash() -> String:
	var file:File = File.new()
	var result:String
	
	if not file.file_exists("id.txt"):
		file.open("id.txt", file.WRITE)
	else:
		file.open("id.txt", file.READ_WRITE)
		result = file.get_as_text()
	
	if(result == ""):
		result = (str(OS.get_ticks_msec()) + str(rand_range(0.0, 128.0))).sha256_text()
		file.store_string(result)
	
	file.close()
	
	return result
