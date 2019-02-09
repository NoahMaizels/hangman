require 'yaml'

game_state = [8,'potato', "******", ['e', 'r', 'j']]
serialized_object = YAML::dump(game_state)
game_file = open('save_game.yaml', 'w')
game_file.puts serialized_object
game_file.close

game_file = open('save_game.yaml', 'r')
game_state = YAML::load(game_file.read)
game_file.close

p game_state