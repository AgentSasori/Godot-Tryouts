extends Node
class_name FielHandler

# Read config file
func read_json_file(file_path:String):
	var file   = File.new()
	var result = false
	
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		result = JSON.parse(file.get_as_text()).get_result()
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

func save_data_as_json(file_path:String, data):
	var file:File = File.new()
	var content = JSON.print(data)
	
	file.open(file_path, file.WRITE_READ)
	
	file.store_string(content)
	
	file.close()
