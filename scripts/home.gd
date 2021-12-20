extends Control

func _ready():
	pass


func navigatedToPlayerNumber():
	get_tree().change_scene("res://scenes/selectNumOfPlayers.tscn")
	print(Globals.gameType)
	
func _on_primeNumbers_pressed():
	Globals.gameType = "PrimeNumbers"
	navigatedToPlayerNumber()

func _on_Addition_pressed():
	Globals.gameType = "Addition"
	navigatedToPlayerNumber()

func _on_Multiplication_pressed():
	Globals.gameType = "Multiplication"
	navigatedToPlayerNumber()

func _on_Subtraction_pressed():
	Globals.gameType = "Subtraction"
	navigatedToPlayerNumber()

func _on_Division_pressed():
	Globals.gameType = "Division"
	navigatedToPlayerNumber()

func _on_Simple_Equations_pressed():
	Globals.gameType = "SimpleEquations"
	navigatedToPlayerNumber()

func _on_Factors_pressed():
	Globals.gameType = "Factors"
	navigatedToPlayerNumber()

func _on_Multiples_pressed():
	Globals.gameType = "Multiples"
	navigatedToPlayerNumber()

func _on_Squares_pressed():
	Globals.gameType = "Squares"
	navigatedToPlayerNumber()

func _on_SquareRoots_pressed():
	Globals.gameType = "SquareRoots"
	navigatedToPlayerNumber()
