extends Control

var numOfQuestionsAnswered = 0
var level = 1
var present = {}
var generalTimeOut = 20
var myTimeout = generalTimeOut
var timerStopped = false
var highest = 50
var fiftyFiftyOn = false
var presentCoins = 0

func setupOptions():
	if Globals.gameType == "PrimeNumbers":
		$userBG/question.text = "Prime Numbers"
	else:
		$userBG/question.text = str(present.operand1) +" "+ Globals.mySign2+" " + str(present.operand2)
	$gameTypeAndLevel.text = Globals.gameType + ",Level " + str(level)
	$userBG/numOutOf.text = str(numOfQuestionsAnswered) + " out of 10"
	$coinArea/coinCount.text = str(presentCoins)
	$coinArea/globalCoins.text = str(Globals.allCoins)
	for i in range(4):
		get_node("userBG/options/answer"+str(i+1)+'/Label').text = str(present.options[i])
	
func getQuetion():
	if Globals.gameType == "Addition":
		present = Globals.createSimple(highest,"+")
	if Globals.gameType == "Subtraction":
		present = Globals.createSimple(highest,"-")
	if Globals.gameType == "Multiplication":
		present = Globals.createSimple(highest,"*")
	if Globals.gameType == "Division":
		present = Globals.createSimple(highest,"/")
	if Globals.gameType == "PrimeNumbers":
		present = Globals.createSimple(highest,"PrimeNumbers")
	setupOptions()

func createTimeout():
	if fiftyFiftyOn == true:
		for i in range(4):
			get_node("userBG/options/answer"+str(i+1)).set('disabled',false)
		fiftyFiftyOn = false
	$TextureProgress.set('max_value',generalTimeOut)
	timerStopped = false
	myTimeout = generalTimeOut

func _process(delta):
	if timerStopped == true and myTimeout < 0: 
		gameOver()
	else:
			$TextureProgress.set('value',myTimeout)
			myTimeout -= delta
			if myTimeout < 0:
				timerStopped = true
	
			
func openLifelines():
	if Globals.allCoins <= 50:
		$userBG/lifeLines/fifty.set("disabled",true)
		$userBG/lifeLines/random.set("disabled",true)
	if Globals.allCoins <= 100:
		$userBG/lifeLines/tip.set("disabled",true)
	if Globals.allCoins >= 50:
		$userBG/lifeLines/fifty.set("disabled",false)
		$userBG/lifeLines/random.set("disabled",false)
	if Globals.allCoins >= 150:
		$userBG/lifeLines/tip.set("disabled",false)

func _ready():
	getQuetion()
	createTimeout()
	openLifelines()
	$gameTypeAndLevel.text = Globals.gameType + ",Level " + str(level) 
	
func gameOver():
	$GameOverScreen.popup()
	if Globals.allCoins < 200:
		$GameOverScreen/saveMeButton.disabled = true
		$GameOverScreen/saveMeButton.set("modulate",Color(1,1,1,0.4))
	else:
		$GameOverScreen/retryButton.disabled = false
	$GameOverScreen/youScored.text = "You reached: level " + str(level) + ',question ' + str(numOfQuestionsAnswered)
	$GameOverScreen/coinsGotten.text = "Coins: " + str(presentCoins)

func answerButtonPressed(extra_arg_0):
	if present.options[extra_arg_0] == present.correctAnswer:
		numOfQuestionsAnswered += 1
		Globals.allCoins += 2
		presentCoins += 2
		setupOptions()
		getQuetion()
		if numOfQuestionsAnswered%10 == 0:
			level += 1
			numOfQuestionsAnswered = numOfQuestionsAnswered%10
		createTimeout()
		openLifelines()
	else:
		timerStopped = true
		gameOver()
		for i in range(4):
			if present.options[i] ==  present.correctAnswer:
				get_node('userBG/options/answer'+str(i+1)).set("modulate",Color(0.3,1,0.3,1))
		
func _on_backButton_pressed():
	var back = get_tree().change_scene("res://scenes/selectNumOfPlayers.tscn")
	print(back)

func autoAnswer():
	Globals.allCoins -= 100
	createTimeout()
	numOfQuestionsAnswered += 1
	Globals.allCoins += 2
	setupOptions()
	getQuetion()
	if numOfQuestionsAnswered%10 == 0:
		level += 1
		numOfQuestionsAnswered = numOfQuestionsAnswered%10
	createTimeout()
	openLifelines()

func _on_fifty_pressed():
	Globals.allCoins -= 50
	var newOptions = [present.correctAnswer]
	while len(newOptions) < 2:
		var otherOption = present.options[randi() % 4]
		if newOptions.has(otherOption) == false:
			newOptions.append(otherOption)
	for i in range(4):
		if present.options[i] == newOptions[0] or present.options[i] == newOptions[1]:
			pass
		else:
			get_node("userBG/options/answer"+str(i+1)).set('disabled',true)
	fiftyFiftyOn = true

func _on_random_pressed():
	_on_fifty_pressed()
	for i in range(4):
		if get_node("userBG/options/answer"+str(i+1)).disabled == false:
			answerButtonPressed(i)
			break

func _on_retryButton_pressed():
	get_tree().change_scene("res://scenes/onePlayer.tscn")
	Globals.allCoins -= presentCoins

func _on_saveMeButton_pressed():
	$GameOverScreen.hide()
	timerStopped = false
	Globals.allCoins -= 200
	for i in range(4):
			if present.options[i] ==  present.correctAnswer:
				get_node('userBG/options/answer'+str(i+1)).set("modulate",Color(1,1,1,1))
