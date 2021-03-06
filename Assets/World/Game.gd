extends Spatial
class_name Game

var is_game_running = false

var player_start: Spatial = null
var player: Control = null
#var players := [Control]

var ai_players = []

func _ready() -> void:
	Global.Game = self
	player_start = Global.PlayerStart
	
	Audio.play_entry_snd()

func _process(_delta: float) -> void:
	if not is_game_running:
		start_game()
	
func start_game() -> void:
	if player_start:
		player = Player.new()
		player.faction = Global.faction

		add_child(player)
		
		# Assign player starter ship
		var ships = player_start.get_children()
		ships[(randi() % ships.size())].faction = player.faction

		var factions: Array = range(1, 15)
		factions.remove(factions.find(player.faction)) # remove occupied faction from array
		
		# Assign AI starter ships
		ai_players.resize(Global.ai_players)
		if ai_players.size() > 0: printt("ai_player", "ship")
		for ai_player in range(ai_players.size()):
			ai_players[ai_player] = factions[randi() % factions.size()] # assign random faction to AI player
			factions.remove(factions.find(ai_players[ai_player])) # remove occupied faction from array
			
			for ship in ships:
				if ship.faction == Global.Factions.NONE:
					ship.faction = ai_players[ai_player]
					printt(ai_players[ai_player], ship.name)
					break
		
		# Remove any ships left over
		for ship in ships:
			if ship.faction == Global.Factions.NONE:
				ship.queue_free()
		
		# Traders
		if not Global.has_traders:
			pass # TODO
		
		# Pirates
		if not Global.has_pirates:
			get_node("Pirates").queue_free()
		
		# Disasters
		if not Global.has_disasters:
			pass # TODO

	is_game_running = true
