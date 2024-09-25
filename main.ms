
import "mathUtil"
import "textUtil"
import "listUtil"
import "stringUtil"
import "chars"

import "updatable"
import "sound"
import "particles"
import "textUI"
import "robots"

clear

musVol = 0.2
soundVol = 1

display(2).mode = displayMode.text
text = display(2)
text.clear

display(3).mode = displayMode.pixel
gfx = display(3)
gfx.clear

display(4).mode = displayMode.sprite
disp = display(4)
disp.clear

display(5).mode = displayMode.tile
tiles = display(5)
tiles.extent = [15, 10]
tiles.clear //1
tiles.tileSet = file.loadImage("pics/front.png")
tiles.tileSetTileSize = 16

mus = file.loadSound("mus.ogg")
mus.loop = true
mus.play
mus.adjust 0.25

// ========= CONSTANTS ===========

moneyColor = color.yellow
stoneColor = "#555555"
coalColor = color.gray
copperColor = color.orange
goldColor = "#FFAA00"
diamondColor = "#44AAFF"

specialOres = [5, 13, 20, 21]

oreValues = {}
oreValues[0] = {"type": "stone", "amount": 0, "color": color.purple} // Bedrock
oreValues[1] = {"type": "stone", "amount": 3, "color": color.silver} // Cobblestone
oreValues[2] = {"type": "stone", "amount": 1, "color": color.silver} // Stone
oreValues[3] = {"type": "coal", "amount": 1, "color": color.black} // Coal
oreValues[4] = {"type": "copper", "amount": 1, "color": color.orange} // Copper
oreValues[5] = {"type": "gold", "amount": 1, "color": color.yellow} // Gold
oreValues[6] = {"type": "crate", "amount": 1, "color": color.brown} // Chest level 1

oreValues[8] = {"type": "stone", "amount": 0, "color": color.purple} // Bedrock
oreValues[9] = {"type": "stone", "amount": 5, "color": color.silver} // Cobblestone
oreValues[10] = {"type": "stone", "amount": 2, "color": color.silver} // Stone
oreValues[11] = {"type": "coal", "amount": 3, "color": color.black} // Coal
oreValues[12] = {"type": "copper", "amount": 2, "color": color.orange} // Copper
oreValues[13] = {"type": "gold", "amount": 2, "color": color.yellow} // Gold
oreValues[14] = {"type": "crate", "amount": 1, "color": color.brown} // Chest level 1

oreValues[16] = {"type": "stone", "amount": 0, "color": color.purple} // Bedrock
oreValues[17] = {"type": "stone", "amount": 8, "color": color.silver} // Cobblestone
oreValues[18] = {"type": "stone", "amount": 3, "color": color.silver} // Stone
oreValues[19] = {"type": "copper", "amount": 5, "color": color.orange} // Copper
oreValues[20] = {"type": "gold", "amount": 3, "color": color.yellow} // Gold
oreValues[21] = {"type": "diamond", "amount": 1, "color": color.aqua} // Diamond
oreValues[22] = {"type": "crate2", "amount": 1, "color": color.brown} // Chest level 2

oreValues[24] = {"type": "stone", "amount": 0, "color": color.purple} // Bedrock
oreValues[25] = {"type": "stone", "amount": 10, "color": color.red} // Cobblestone
oreValues[26] = {"type": "stone", "amount": 5, "color": color.red} // Stone
oreValues[27] = {"type": "gold", "amount": 5, "color": color.yellow} // Gold
oreValues[28] = {"type": "diamond", "amount": 3, "color": color.aqua} // Diamond
oreValues[29] = {"type": "random", "amount": 1, "color": color.white} // Random
oreValues[30] = {"type": "crate2", "amount": 1, "color": color.brown} // Chest level 2

oreValues[32] = {"type": "stone", "amount": 0, "color": color.purple} // Bedrock
oreValues[33] = {"type": "stone", "amount": 15, "color": color.orange} // Cobblestone
oreValues[34] = {"type": "stone", "amount": 7, "color": color.orange} // Stone
oreValues[35] = {"type": "gold", "amount": 10, "color": color.yellow} // Gold
oreValues[36] = {"type": "diamond", "amount": 5, "color": color.aqua} // Diamond
oreValues[37] = {"type": "random", "amount": 1, "color": color.white} // Random
oreValues[38] = {"type": "crate3", "amount": 1, "color": color.brown} // Chest level 3

oreValues[40] = {"type": "random", "amount": 1, "color": color.black} // Random

sellValues = {}
sellValues["stone"] = 1
sellValues["coal"] = 3
sellValues["copper"] = 7
sellValues["gold"] = 50
sellValues["diamond"] = 100

healthValues = {}
healthValues[1] = 2 // Cobblestone
healthValues[2] = 2 // Stone
healthValues[3] = 3 // Coal
healthValues[4] = 5 // Copper
healthValues[5] = 10 // Gold
healthValues[6] = 25 // Chest

healthValues[9] = 3 // Cobblestone
healthValues[10] = 3 // Stone
healthValues[11] = 5 // Coal
healthValues[12] = 10 // Copper
healthValues[13] = 25 // Gold
healthValues[14] = 50 // Chest

healthValues[17] = 7 // Cobblestone
healthValues[18] = 7 // Stone
healthValues[19] = 15 // Copper
healthValues[20] = 30 // Gold
healthValues[21] = 40 // Diamond
healthValues[22] = 100 // Chest

healthValues[25] = 15 // Cobblestone
healthValues[26] = 15 // Stone
healthValues[27] = 40 // Gold
healthValues[28] = 45 // Diamond
healthValues[29] = 50 // Random
healthValues[30] = 100 // Chest

healthValues[33] = 35 // Cobblestone
healthValues[34] = 35 // Stone
healthValues[35] = 80 // Gold
healthValues[36] = 100 // Diamond
healthValues[37] = 100 // Random
healthValues[38] = 150 // Chest

healthValues[40] = 10000 // Lava

cellAfterMinedValues = {}
cellAfterMinedValues[1] = 0 // Cobblestone
cellAfterMinedValues[2] = 1 // Stone
cellAfterMinedValues[3] = 2 // Coal
cellAfterMinedValues[4] = 2 // Copper
cellAfterMinedValues[5] = 2 // Gold
cellAfterMinedValues[6] = 2 // Chest

cellAfterMinedValues[9] = 8 // Cobblestone
cellAfterMinedValues[10] = 9 // Stone
cellAfterMinedValues[11] = 10 // Coal
cellAfterMinedValues[12] = 10 // Copper
cellAfterMinedValues[13] = 10 // Gold
cellAfterMinedValues[14] = 10 // Chest

cellAfterMinedValues[17] = 16 // Cobblestone
cellAfterMinedValues[18] = 17 // Stone
cellAfterMinedValues[19] = 18 // Copper
cellAfterMinedValues[20] = 18 // Gold
cellAfterMinedValues[21] = 18 // Diamond
cellAfterMinedValues[22] = 18 // Chest

cellAfterMinedValues[25] = 24 // Cobblestone
cellAfterMinedValues[26] = 25 // Stone
cellAfterMinedValues[27] = 26 // Gold
cellAfterMinedValues[28] = 26 // Diamond
cellAfterMinedValues[29] = 26 // Random
cellAfterMinedValues[30] = 26 // Chest

cellAfterMinedValues[33] = 32 // Cobblestone
cellAfterMinedValues[34] = 33 // Stone
cellAfterMinedValues[35] = 34 // Gold
cellAfterMinedValues[36] = 34 // Diamond
cellAfterMinedValues[37] = 34 // Random
cellAfterMinedValues[38] = 34 // Chest

itemDescriptions = {}
itemDescriptions["speedKeyOne"] = {"name": "Level 1 Speed Key", "description": "Speeds up all robots by 10%. Applies to movement and mining speed."}
itemDescriptions["speedKeyTwo"] = {"name": "Level 2 Speed Key", "description": "Speeds up all robots by 25%. Applies to movement and mining speed."}
itemDescriptions["speedKeyThree"] = {"name": "Level 3 Speed Key", "description": "Speeds up all robots by 50%. Applies to movement and mining speed."}

itemDescriptions["fortuneKeyOne"] = {"name": "Level 1 Fortune Key", "description": "Ores drop 5% more. Applies to manual and robot mining."}
itemDescriptions["fortuneKeyTwo"] = {"name": "Level 2 Fortune Key", "description": "Ores drop 10% more. Applies to manual and robot mining."}
itemDescriptions["fortuneKeyThree"] = {"name": "Level 3 Fortune Key", "description": "Ores drop 25% more. Applies to manual and robot mining."}

// ========= GAME VARIABLES ===========

money = 0

stone = 0
coal = 0
copper = 0
gold = 0
diamond = 0

// ========= STATS =========

breakStrength = 1
sellMultiplier = 1.0
oreRegen = 1.0
stoneRegen = 1.0

coolerUpgrade = 0
pickaxeUpgrade = 0

crates = []
speedKeyOneCount = 0
speedKeyTwoCount = 0
speedKeyThreeCount = 0

fortuneKeyOneCount = 0
fortuneKeyTwoCount = 0
fortuneKeyThreeCount = 0

// ========= HELPER FUNCTIONS ==========

Sprite.isOnScreen = function
	if self.x + 64 - disp.scrollX <= 0 then return false
	if self.x - 64 - disp.scrollX >= 960 then return false
	if self.y + 64 - disp.scrollY <= 0 then return false
	if self.y - 64 - disp.scrollY >= 960 then return false
	return true
end function

// Function to perform a weighted random selection
weightedRandom = function(items)
    totalWeight = 0
    
    // Sum up the total weight
    for item in items
        totalWeight += item[1]  // item[1] is the weight
    end for
    
    randValue = rnd * totalWeight
    
    runningSum = 0
    for item in items
        runningSum += item[1]  // Add the weight of each item
        if randValue < runningSum then
            return item[0]  // Return the "thing" when randValue is within this item's weight range
        end if
    end for
end function

formatNumber = function(num, roundAmt=0)
    if num >= 1000000 then
        return round(num / 1000000, 1) + "m"
    else if num >= 1000 then
        return round(num / 1000, 1) + "k"
    else
        return round(num, roundAmt) + ""
    end if
end function

lastIndexOf = function(s, char)
    for i in range(s.len-1, 0, -1)
        if s[i] == char then return i
    end for
    return null  // Return null if the character is not found
end function

// ========= UI ========

windowActive = false

initUI = function
    crates = textUI.Button.make(55, 6, 13, "CRATES")
	crates.start
	crates.action = function 
        if not windowActive then crateScreen
    end function
    shop = textUI.Button.make(55, 10, 13, "SHOP")
	shop.start
	shop.action = function 
        if not windowActive then buyScreen
    end function
    sell = textUI.Button.make(55, 8, 13, "SELL")
	sell.start
	sell.action = function 
        if not windowActive then sellScreen
    end function
    craft = textUI.Button.make(55, 4, 13, "CRAFT")
	craft.start
	craft.action = function
        if not windowActive then craftScreen
	end function
    help = textUI.Button.make(55, 2, 13, "HELP")
	help.start
	help.action = function
        if not windowActive then helpScreen
	end function
    settings = textUI.Button.make(55, 0, 13, "SETTINGS")
	settings.start
	settings.action = function
        if not windowActive then settingsScreen
	end function
    moveUp = textUI.Button.make(51, 25, 3, chars.upArrow)
    moveUp.normalColor = "#000000"
	moveUp.start
	moveUp.action = function
        if globals.currentChunk == 0 then return
        disp.scrollY += 640
        tiles.scrollY += 640
        globals.currentChunk += 1
	end function
    moveDown = textUI.Button.make(51, 0, 3, chars.downArrow)
    moveDown.normalColor = "#000000"
	moveDown.start
	moveDown.action = function
        if globals.currentChunk <= -globals.chunks.len+1 then return
        if coolerUpgrade <= -globals.currentChunk then return
        disp.scrollY -= 640
        tiles.scrollY -= 640
        globals.currentChunk -= 1
	end function
end function

updateUI = function
    gfx.fillRect 960-64*3, 0, 64*3, 640, color.black
    textUtil.clearRect 55, 12, 13, 14
    text.color = moneyColor
    textUtil.printAt(55, 25, "Money: " + formatNumber(money))
    text.color = stoneColor
    textUtil.printAt(55, 23, "Stone: " + formatNumber(stone))
    text.color = coalColor
    textUtil.printAt(55, 22, "Coal: " + formatNumber(coal))
    text.color = copperColor
    textUtil.printAt(55, 21, "Copper: " + formatNumber(copper))
    text.color = goldColor
    textUtil.printAt(55, 20, "Gold: " + formatNumber(gold))
    text.color = diamondColor
    textUtil.printAt(55, 19, "Diamond: " + formatNumber(diamond))
    text.color = color.brown
    textUtil.printAt(55, 18, "Crates: " + globals.crates.len + "   ")
end function

sellScreen = function
    globals.windowActive = true
    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    sell = textUI.Button.make(5, 3, 12, "SELL")
	sell.start
	sell.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        globals.money += floor(moneyTotal)
        if globals.stone > 0 then globals.stone -= floor(stoneSlider.value) 
        if globals.coal > 0 then globals.coal -= floor(coalSlider.value)
        if globals.copper > 0 then globals.copper -= floor(copperSlider.value)
        if globals.gold > 0 then globals.gold -= floor(goldSlider.value)
        if globals.diamond > 0 then globals.diamond -= floor(diamondSlider.value)
        //updateUI
        sound.purchase.play
        sound.purchase.adjust globals.soundVol
        return
	end function

    sliders = []
    
    if stone > 0 then
        text.color = globals.stoneColor 
        textUtil.printAt 5, 22, "Sell Stone:"
	    stoneSlider = textUI.Slider.make(5, 21, 30)
	    stoneSlider.action = function(x); textUtil.printAt 36, 21, formatNumber(floor(x)) + " "*8; end function
	    stoneSlider.maxValue = stone
	    stoneSlider.start
        stoneSlider.action 0
        sliders.push stoneSlider
    end if

    if coal > 0 then
        text.color = globals.coalColor 
        textUtil.printAt 5, 20, "Sell Coal:"
	    coalSlider = textUI.Slider.make(5, 19, 30)
	    coalSlider.action = function(x); textUtil.printAt 36, 19, formatNumber(floor(x)) + " "*8; end function
	    coalSlider.maxValue = coal
	    coalSlider.start
        coalSlider.action 0
        sliders.push coalSlider
    end if

    if copper > 0 then
        text.color = globals.copperColor
        textUtil.printAt 5, 18, "Sell Copper:"
	    copperSlider = textUI.Slider.make(5, 17, 30)
	    copperSlider.action = function(x); textUtil.printAt 36, 17, formatNumber(floor(x)) + " "*8; end function
	    copperSlider.maxValue = copper
	    copperSlider.start
        copperSlider.action 0
        sliders.push copperSlider
    end if

    if gold > 0 then
        text.color = globals.goldColor 
        textUtil.printAt 5, 16, "Sell Gold:"
	    goldSlider = textUI.Slider.make(5, 15, 30)
	    goldSlider.action = function(x); textUtil.printAt 36, 15, formatNumber(floor(x)) + " "*8; end function
	    goldSlider.maxValue = gold
	    goldSlider.start
        goldSlider.action 0
        sliders.push goldSlider
    end if

    if diamond > 0 then
        text.color = globals.diamondColor 
        textUtil.printAt 5, 14, "Sell Diamond:"
	    diamondSlider = textUI.Slider.make(5, 13, 30)
	    diamondSlider.action = function(x); textUtil.printAt 36, 13, formatNumber(floor(x)) + " "*8; end function
	    diamondSlider.maxValue = diamond
	    diamondSlider.start
        diamondSlider.action 0
        sliders.push diamondSlider
    end if

    moneyTotal = 0

    while true
        if windowActive == false then 
            exit.stop
            sell.stop
            for s in sliders
                s.stop
            end for
            textUtil.clearRect 4, 2, 46, 22
            updateUI
            return
        end if
        textUI.update

        moneyTotal = 0

        if stone > 0 then moneyTotal += floor(stoneSlider.value) * sellValues["stone"]
        if coal > 0 then moneyTotal += floor(coalSlider.value) * sellValues["coal"]
        if copper > 0 then moneyTotal += floor(copperSlider.value) * sellValues["copper"]
        if gold > 0 then moneyTotal += floor(goldSlider.value) * sellValues["gold"]
        if diamond > 0 then moneyTotal += floor(diamondSlider.value) * sellValues["diamond"]

        moneyTotal *= sellMultiplier

        text.color = globals.moneyColor 
        textUtil.printAt 5, 4, "Money Total: " + formatNumber(moneyTotal) + "      "

        yield
    end while
end function

BuyButton = new textUI.Button
BuyButton.cost = 0
BuyButton.costMultiplier = 30
BuyButton.buyAmountMultiplier = 1
BuyButton.exponent = 3
BuyButton.buyResult = ["breakStrength", 1]
BuyButton.text = "Break Strength: "

BuyButton.make = function(column, row, width=12)
    noob = new self
	noob.fromCol = column; noob.toCol = column+width-1
	noob.fromRow = row; noob.toRow = row
	noob = super.make(column, row, width, "")
	//noob.caption = ""
	return noob
end function

BuyButton.updateCost = function
    self.cost = ceil(self.costMultiplier * (self.exponent ^ (globals[self.buyResult[0]]*self.buyAmountMultiplier)))
end function

BuyButton.updateText = function
    text.color = color.yellow
    textUtil.printAt self.fromCol, self.fromRow+1, self.text + formatNumber(globals[self.buyResult[0]], 1) + "    "
    self.caption = "Buy For: " + formatNumber(self.cost)
    self.draw
end function

BuyButton.action = function
    if globals.money >= self.cost then
        globals.money -= self.cost
        globals[self.buyResult[0]] += self.buyResult[1]
        sound.ranger.play
        sound.ranger.adjust globals.soundVol
    end if
    self.updateCost
    self.updateText
    updateUI
    return
end function

buyScreen = function
    globals.windowActive = true
    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black

    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    breakButton = BuyButton.make(5, 21, 18)
    breakButton.costMultiplier = 25
    breakButton.buyAmountMultiplier = 1
    breakButton.exponent = 2.5
    breakButton.buyResult = ["breakStrength", 0.75]
    breakButton.text = "Break Strength: "
    breakButton.updateCost
    breakButton.updateText
    breakButton.start

    sellMultiButton = BuyButton.make(5, 19, 18)
    sellMultiButton.costMultiplier = 10
    sellMultiButton.buyAmountMultiplier = 5
    sellMultiButton.exponent = 2
    sellMultiButton.buyResult = ["sellMultiplier", 0.2]
    sellMultiButton.text = "Sell Multiplier: "
    sellMultiButton.updateCost
    sellMultiButton.updateText
    sellMultiButton.start

    oreRegenButton = BuyButton.make(5, 17, 18)
    oreRegenButton.costMultiplier = 25
    oreRegenButton.buyAmountMultiplier = 3
    oreRegenButton.exponent = 1.75
    oreRegenButton.buyResult = ["oreRegen", 0.5]
    oreRegenButton.text = "Ore Regeneration Multiplier: " 
    oreRegenButton.updateCost
    oreRegenButton.updateText
    oreRegenButton.start

    stoneRegenButton = BuyButton.make(5, 15, 18)
    stoneRegenButton.costMultiplier = 10
    stoneRegenButton.buyAmountMultiplier = 3
    stoneRegenButton.exponent = 1.5
    stoneRegenButton.buyResult = ["stoneRegen", 0.5]
    stoneRegenButton.text = "Stone Regeneration Multiplier: "
    stoneRegenButton.updateCost
    stoneRegenButton.updateText
    stoneRegenButton.start

    coolerButton = BuyButton.make(5, 13, 18)
    coolerButton.costMultiplier = 100
    coolerButton.buyAmountMultiplier = 5
    coolerButton.exponent = 1.5
    coolerButton.buyResult = ["coolerUpgrade", 1]
    coolerButton.text = "Cooler Upgrade: "
    coolerButton.updateCost
    coolerButton.updateText
    coolerButton.start

    while true
        if windowActive == false then 
            exit.stop
            breakButton.stop
            sellMultiButton.stop
            oreRegenButton.stop
            stoneRegenButton.stop
            coolerButton.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        textUI.update

        text.color = globals.moneyColor 

        yield
    end while
end function

CraftButton = new textUI.Button
CraftButton.cost = {"stone": 0, "coal": 0, "copper": 0, "gold": 0, "diamond": 0}
CraftButton.buyResult = "LvlOneRobot"
CraftButton.text = "Level One Robot: "
CraftButton.color = color.yellow

CraftButton.make = function(column, row, width=12)
    noob = new self
	noob.fromCol = column; noob.toCol = column+width-1
	noob.fromRow = row; noob.toRow = row
	noob.caption = ""
	return noob
end function

CraftButton.updateText = function
    text.color = self.color
    textUtil.printAt self.fromCol, self.fromRow+1, self.text

    costString = ""
    for c in self.cost
        if c.value == 0 then continue
        costString += formatNumber(c.value) + " " + str(c.key).capitalized + ", "
    end for

    costString -= ", "

    self.caption = "Buy: " + costString
    self.draw
end function

CraftButton.action = function
    
    canBuy = true
    for c in self.cost
        if c.value == 0 then continue
        if globals[c.key] < c.value then 
            canBuy = false
            break
        end if
    end for

    if canBuy == true then
        for c in self.cost
            if c.value == 0 then continue
            globals[c.key] -= c.value
        end for

        r = new robots[self.buyResult]
        r.chunkIndex = globals.currentChunk
        r.init
        
        sound.ranger.play
        sound.ranger.adjust globals.soundVol
    end if
    self.updateText
    updateUI
    return
end function

craftScreen = function
    globals.windowActive = true
    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    robotOne = CraftButton.make(5, 21, 40)
    robotOne.cost = {"stone": 40, "coal": 15, "copper": 0, "gold": 0, "diamond": 0}
    robotOne.buyResult = "LvlOneRobot"
    robotOne.text = "Level One Robot: "
    robotOne.color = stoneColor
    robotOne.updateText
    robotOne.start

    robotTwo = CraftButton.make(5, 19, 40)
    robotTwo.cost = {"stone": 100, "coal": 25, "copper": 5, "gold": 0, "diamond": 0}
    robotTwo.buyResult = "LvlTwoRobot"
    robotTwo.text = "Level Two Robot: "
    robotTwo.color = coalColor
    robotTwo.updateText
    robotTwo.start

    robotThree = CraftButton.make(5, 17, 40)
    robotThree.cost = {"stone": 100, "coal": 50, "copper": 75, "gold": 0, "diamond": 0}
    robotThree.buyResult = "LvlThreeRobot"
    robotThree.text = "Level Three Robot: "
    robotThree.color = copperColor
    robotThree.updateText
    robotThree.start

    robotFour = CraftButton.make(5, 15, 40)
    robotFour.cost = {"stone": 500, "coal": 150, "copper": 250, "gold": 10, "diamond": 0}
    robotFour.buyResult = "LvlFourRobot"
    robotFour.text = "Level Four Robot: "
    robotFour.color = goldColor
    robotFour.updateText
    robotFour.start

    robotFive = CraftButton.make(5, 13, 40)
    robotFive.cost = {"stone": 0, "coal": 1000, "copper": 0, "gold": 500, "diamond": 100}
    robotFive.buyResult = "LvlFiveRobot"
    robotFive.text = "Level Five Robot: "
    robotFive.color = diamondColor
    robotFive.updateText
    robotFive.start

    wiperRobot = CraftButton.make(5, 11, 40)
    wiperRobot.cost = {"stone": 1000, "coal": 0, "copper": 300, "gold": 25, "diamond": 0}
    wiperRobot.buyResult = "WiperRobot"
    wiperRobot.text = "Wiper Robot: "
    wiperRobot.color = "#AAAAFF"
    wiperRobot.updateText
    wiperRobot.start

    blasterRobot = CraftButton.make(5, 9, 40)
    blasterRobot.cost = {"stone": 0, "coal": 0, "copper": 1500, "gold": 750, "diamond": 250}
    blasterRobot.buyResult = "BlasterRobot"
    blasterRobot.text = "Blaster Robot: "
    blasterRobot.color = "#AA5577"
    blasterRobot.updateText
    blasterRobot.start

    updatePickaxeCost = function
        if globals.pickaxeUpgrade == 0 then
            outer.pickaxeCost = {}
            outer.pickaxeCost["stone"] = 400
            outer.pickaxeCost["copper"] = 100
        else if globals.pickaxeUpgrade == 1 then
            outer.pickaxeCost = {}
            outer.pickaxeCost["copper"] = 500
            outer.pickaxeCost["gold"] = 50
        else
            outer.pickaxeCost = {}
            outer.pickaxeCost["gold"] = 500
            outer.pickaxeCost["diamond"] = 50
        end if
    end function
    updatePickaxeCost
    text.color = color.white
    textUtil.printAt 5, 8, "Pickaxe: "
    if globals.pickaxeUpgrade == 0 then
        pickaxe = textUI.Button.make(5, 7, 40, "Buy For: " + formatNumber(pickaxeCost.stone) + " Stone, " + formatNumber(pickaxeCost.copper) + " Copper")
    else if globals.pickaxeUpgrade == 1 then
        pickaxe = textUI.Button.make(5, 7, 40, "Buy For: " + formatNumber(pickaxeCost.copper) + " Copper, " + formatNumber(pickaxeCost.gold) + " Gold")
    else
        pickaxe = textUI.Button.make(5, 7, 40, "Buy For: " + formatNumber(pickaxeCost.gold) + " Gold, " + formatNumber(pickaxeCost.diamond) + " Diamond")
    end if
	pickaxe.start
	pickaxe.action = function
        if globals.pickaxeUpgrade == 0 then
            if globals.stone >= pickaxeCost.stone and globals.copper >= pickaxeCost.copper then
                globals.stone -= pickaxeCost.stone
                globals.copper -= pickaxeCost.copper
                globals.pickaxeUpgrade += 1
                sound.craft.play
                sound.craft.adjust globals.soundVol
            end if
        else if globals.pickaxeUpgrade == 1 then
            if globals.copper >= pickaxeCost.copper and globals.gold >= pickaxeCost.gold then
                globals.copper -= pickaxeCost.copper
                globals.gold -= pickaxeCost.gold
                globals.pickaxeUpgrade += 1
                sound.craft.play
                sound.craft.adjust globals.soundVol
            end if
        else
            if globals.gold >= pickaxeCost.gold and globals.diamond >= pickaxeCost.diamond then
                globals.gold -= pickaxeCost.gold
                globals.diamond -= pickaxeCost.diamond
                globals.pickaxeUpgrade += 1
                sound.craft.play
                sound.craft.adjust globals.soundVol
            end if
        end if

        updatePickaxeCost
        textUtil.printAt 5, 8, "Pickaxe: "

        if globals.pickaxeUpgrade == 0 then
            self.caption = "Buy For: " + formatNumber(pickaxeCost.stone) + " Stone, " + formatNumber(pickaxeCost.copper) + " Copper"
        else if globals.pickaxeUpgrade == 1 then
            self.caption = "Buy For: " + formatNumber(pickaxeCost.copper) + " Copper, " + formatNumber(pickaxeCost.gold) + " Gold"
        else
            self.caption = "Buy For: " + formatNumber(pickaxeCost.gold) + " Gold, " + formatNumber(pickaxeCost.diamond) + " Diamond"
        end if
    
        self.draw
        updateUI
        return
	end function

    while true
        if windowActive == false then 
            exit.stop
            robotOne.stop
            robotTwo.stop
            robotThree.stop
            robotFour.stop
            robotFive.stop
            wiperRobot.stop
            blasterRobot.stop
            pickaxe.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        textUI.update

        text.color = globals.moneyColor 

        yield
    end while
end function

helpScreen = function
    globals.windowActive = true
    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    text.color = color.white
    textUtil.printAt 5, 22, "Click on ores to mine them. When you"
    textUtil.printAt 5, 21, "have enough, press the sell button to sell"
    textUtil.printAt 5, 20, "your ores."
    textUtil.printAt 5, 19, "When you have upgraded your cooler, press"
    textUtil.printAt 5, 18, "the arrow buttons to go deeper into the mine."

    text.color = color.yellow
    textUtil.printAt 5, 16, "SHOP UPGRADES"
    textUtil.printAt 5, 15, "Break Strength: Does more damage to ores"
    textUtil.printAt 5, 14, "on hit."
    textUtil.printAt 5, 13, "Sell Multi: Ores sell for more money."
    textUtil.printAt 5, 12, "Ore Regen: Ores will regenerate quicker."
    textUtil.printAt 5, 11, "Stone Regen: Stone will regenerate quicker."
    textUtil.printAt 5, 10, "Cooler: Allows you to go deeper into"
    textUtil.printAt 5, 9, "the mine."

    text.color = color.orange
    textUtil.printAt 5, 7, "CRAFTING"
    textUtil.printAt 5, 6, "Robots: Robots will mine ores for you"
    textUtil.printAt 5, 5, "automatically."
    textUtil.printAt 5, 4, "Pickaxe: Does more damage to ores on hit"

    while true
        if windowActive == false then 
            exit.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        textUI.update
        yield
    end while
end function

settingsScreen = function
    globals.windowActive = true
    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    text.color = color.white
    textUtil.printAt 5, 22, "Music Volume:"
	musicSlider = textUI.Slider.make(5, 21, 21)
	musicSlider.action = function(x) 
        textUtil.printAt 27, 21, x + " "*8; 
        globals.mus.adjust x
        globals.musVol = x
    end function
	musicSlider.maxValue = 1
    musicSlider.value = globals.musVol
	musicSlider.start
    musicSlider.action globals.musVol

    textUtil.printAt 5, 19, "Sound Volume:"
	soundSlider = textUI.Slider.make(5, 18, 21)
	soundSlider.action = function(x) 
        textUtil.printAt 27, 18, x + " "*8; 
        globals.soundVol = x
    end function
	soundSlider.maxValue = 2
    soundSlider.value = globals.soundVol
	soundSlider.start
    soundSlider.action globals.soundVol

    while true
        if windowActive == false then 
            exit.stop
            musicSlider.stop
            soundSlider.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        textUI.update
        yield
    end while
end function

crateScreen = function
    globals.windowActive = true

    getSingleValueInList = function(ls, value)
        uniqueList = []
        for num in ls
            if num == value then
                uniqueList.push(1)
            end if
        end for
        return uniqueList
    end function

    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    openChest = 0

    lvl1CrateAmount = getSingleValueInList(globals.crates, 1).len
    textUtil.printAt 5, 22, "Level 1 Crates: " + lvl1CrateAmount + "    "
    lvl1Crate = textUI.Button.make(5, 21, 18, "OPEN")
	lvl1Crate.start
	lvl1Crate.action = function
        if lvl1CrateAmount != 0 then
            outer.openChest = 1
        end if
        textUtil.printAt 5, 22, "Level 1 Crates: " + lvl1CrateAmount + "    "
        self.draw
        updateUI
	end function

    lvl2CrateAmount = getSingleValueInList(globals.crates, 2).len
    textUtil.printAt 5, 20, "Level 2 Crates: " + lvl2CrateAmount + "    "
    lvl2Crate = textUI.Button.make(5, 19, 18, "OPEN")
	lvl2Crate.start
	lvl2Crate.action = function
        if lvl2CrateAmount != 0 then
            outer.openChest = 2
        end if
        textUtil.printAt 5, 20, "Level 2 Crates: " + lvl2CrateAmount + "    "
        self.draw
        updateUI
	end function

    lvl3CrateAmount = getSingleValueInList(globals.crates, 3).len
    textUtil.printAt 5, 18, "Level 3 Crates: " + lvl3CrateAmount + "    "
    lvl3Crate = textUI.Button.make(5, 17, 18, "OPEN")
	lvl3Crate.start
	lvl3Crate.action = function
        if lvl3CrateAmount != 0 then
            outer.openChest = 3
        end if
        textUtil.printAt 5, 18, "Level 3 Crates: " + lvl3CrateAmount + "    "
        self.draw
        updateUI
	end function

    while true
        if windowActive == false then 
            exit.stop
            lvl1Crate.stop
            lvl2Crate.stop
            lvl3Crate.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        if openChest != 0 then 
            globals.crates.removeVal openChest
            exit.stop
            lvl1Crate.stop
            lvl2Crate.stop
            lvl3Crate.stop
            textUtil.clearRect 4, 2, 46, 22
            chestScreen openChest
        end if

        textUI.update

        text.color = globals.moneyColor 

        yield
    end while
end function

chestScreen = function(lvl)
    globals.windowActive = true

    textUI.update

    text.color = color.yellow

    textUtil.printCenteredAt 27, 22, "You found a level " + lvl +  " chest!"

    gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.black
    exit = textUI.Button.make(46, 22, 3, "X")
	exit.start
	exit.action = function
        globals.windowActive = false
        gfx.fillRect 64, 64, 960-64*5, 640-64*2, color.clear
        return
	end function

    prize = getChestPrize(lvl)
    if prize isa string then
        globals[prize + "Count"] += 1
        textUtil.printAt(5, 19, "You found a " + itemDescriptions[prize].name + "!")
        printPrizeText itemDescriptions[prize].description

        textUtil.printAt(5, 3, "Total " + itemDescriptions[prize].name + "s: " + globals[prize + "Count"])
    else
        textUtil.printAt(5, 19, "You found:")
        for i in range(0, prize.len-1)
            globals[prize[i][0]] += prize[i][1]
            textUtil.printAt(5, 17 - i*2, prize[i][1] + " " + prize[i][0])
        end for
    end if

    updateUI

    while true
        if windowActive == false then 
            exit.stop
            textUtil.clearRect 4, 2, 46, 22
            return
        end if
        textUI.update
        yield
    end while
end function

printPrizeText = function(txt)
	maxLength = 40
	chunks = []

	while txt.len > 0
		// Find the largest substring that fits within maxLength
		if txt.len <= maxLength then
			chunk = txt  // If the remaining text is short enough, take it all
			txt = ""  // Clear the remaining text
		else
			// Look for the last space within the maxLength boundary
			chunk = txt[:maxLength]
			spaceIndex = lastIndexOf(chunk, " ")
			if spaceIndex == null then
				spaceIndex = maxLength  // No space found, so take the max length
			end if
			
			chunk = txt[:spaceIndex]  // Take up to the space
			txt = txt[spaceIndex+1:]  // Remove the chunk (plus the space) from text
		end if
		
		chunks.push(chunk)  // Add the chunk to the list
	end while

	for i in range(0, chunks.len-1)
		textUtil.printAt(5, 16-i*2, chunks[i])
	end for
end function

getChestPrize = function(lvl=1)
    prize = []
    if lvl == 1 then
        random = rnd
        if random <= 0.5 then
            prize.push ["stone", ceil(mathUtil.randRange(100, 200))]
            prize.push ["coal", ceil(mathUtil.randRange(20, 50))]
            if rnd < 0.6 then prize.push ["copper", ceil(mathUtil.randRange(20, 50))]
            if rnd < 0.3 then prize.push ["gold", ceil(mathUtil.randRange(1, 5))]
        else if random <= 0.75 then
            prize = "speedKeyOne"
        else
            prize = "fortuneKeyOne"
        end if
    else if lvl == 2 then
        random = rnd
        if random <= 0.5 then
            prize.push ["coal", ceil(mathUtil.randRange(150, 200))]
            prize.push ["copper", ceil(mathUtil.randRange(50, 175))]
            if rnd < 0.7 then prize.push ["gold", ceil(mathUtil.randRange(10, 25))]
            if rnd < 0.4 then prize.push ["diamond", ceil(mathUtil.randRange(2, 10))]
        else if random <= 0.75 then
            prize = "speedKeyTwo"
        else
            prize = "fortuneKeyTwo"
        end if
    else
        random = rnd
        if random <= 0.5 then
            prize.push ["coal", ceil(mathUtil.randRange(250, 500))]
            prize.push ["copper", ceil(mathUtil.randRange(200, 500))]
            if rnd < 0.8 then prize.push ["gold", ceil(mathUtil.randRange(100, 500))]
            if rnd < 0.5 then prize.push ["diamond", ceil(mathUtil.randRange(10, 50))]
        else if random <= 0.7 then
            prize = "speedKeyThree"
        else
            prize = "fortuneKeyThree"
        end if
    end if
    return prize
end function

// ========= LEVEL CHUNK SYSTEM ==========

chunks = []
cellHealth = []
currentChunk = 0

Chunk = {}
Chunk.baseTileIdx = 2
Chunk.spawns = [[3, 25], [4, 10], [5, 2]] // List of the tileset index and the spawn weight
Chunk.spawnTime = [0.3, 2]
Chunk.stoneTime = [0.1, 0.4]

Chunk.lastSpawnTime = 0
Chunk.nextSpawnTime = 0

Chunk.lastStoneTime = 0
Chunk.nextStoneTime = 0

Chunk.chunkNum = 0

Chunk.update = function
    self.regenerateOre
    self.regenerateStone
    self.spawnSparkles
end function

Chunk.regenerateOre = function
    if time < self.lastSpawnTime + (self.nextSpawnTime / oreRegen) then return

    self.lastSpawnTime = time
    self.nextSpawnTime = mathUtil.randRange(self.spawnTime[0], self.spawnTime[1])

    randX = mathUtil.randRange(0, 12)
    randY = mathUtil.randRange(chunks.len*10, chunks.len*10+10)

    cellX = floor(randX)
    cellY = floor(randY-self.chunkNum*10)
    cell = tiles.cell(cellX, cellY)

    if cell == self.baseTileIdx then 
        ore = weightedRandom(self.spawns)
        tiles.setCell(cellX, cellY, ore)
        cellHealth[cellY][cellX] = healthValues[ore]
        if currentChunk != -chunks.indexOf(self) then return
        oreValue = oreValues[ore]
        particles.OreParticle.make cellX*64+32, cellY*64+32, 6, oreValue.color
        sound.spawn.play
        sound.spawn.adjust globals.soundVol
    end if
end function

Chunk.regenerateStone = function
    if time < self.lastStoneTime + (self.nextStoneTime / stoneRegen) then return

    self.lastStoneTime = time
    self.nextStoneTime = mathUtil.randRange(self.stoneTime[0], self.stoneTime[1])

    randX = mathUtil.randRange(0, 12)
    randY = mathUtil.randRange(chunks.len*10, chunks.len*10+10)

    cellX = floor(randX)
    cellY = floor(randY-self.chunkNum*10)
    cell = tiles.cell(cellX, cellY)

    if cell == self.baseTileIdx - 1 then
        stone = self.baseTileIdx
        tiles.setCell(cellX, cellY, stone)
        cellHealth[cellY][cellX] = healthValues[stone]
    else if cell == self.baseTileIdx - 2 then
        stone = self.baseTileIdx - 1
        tiles.setCell(cellX, cellY, stone)
        cellHealth[cellY][cellX] = healthValues[stone]
    end if
end function

Chunk.spawnSparkles = function
    if rnd > 0.3 then return
    if currentChunk != -chunks.indexOf(self) then return
    randX = mathUtil.randRange(0, 12)
    randY = mathUtil.randRange(chunks.len*10, chunks.len*10+10)

    cellX = floor(randX)
    cellY = floor(randY-self.chunkNum*10)
    cell = tiles.cell(cellX, cellY)
    if specialOres.indexOf(cell) != null then 
        sound.shine.play
        sound.shine.adjust globals.soundVol, 0, mathUtil.randRange(0.9, 1.1)
        particles.SparkleParticle.make cellX*64+64*rnd, cellY*64+64*rnd, 1, color.white
    end if
end function

Chunk.make = function(baseTileIdx, spawns, spawnTime, stoneTime)
    c = new Chunk
    c.baseTileIdx = baseTileIdx
    c.spawns = spawns
    c.spawnTime = spawnTime
    c.stoneTime = stoneTime
    return c
end function

initChunks = function
    chunks.push Chunk.make(2, [[3, 25], [4, 10], [5, 2], [6, 0.5]], [0.3, 2], [0.1, 0.2])
    chunks.push Chunk.make(10, [[11, 30], [12, 15], [13, 3], [14, 1]], [0.6, 4], [0.2, 0.8])
    chunks.push Chunk.make(18, [[19, 25], [20, 10], [21, 2], [22, 1.2]], [1.4, 5], [0.4, 1.5])
    chunks.push Chunk.make(26, [[27, 25], [28, 10], [29, 30], [30, 1.8]], [1.5, 6], [0.6, 2])
    chunks.push Chunk.make(34, [[35, 45], [36, 20], [37, 35], [38, 2]], [2, 7], [1, 3])
    chunks.push Chunk.make(40, [[40, 25]], [2, 7], [1, 3])

    tiles.extent = [12, chunks.len*10]
    chunkNum = 0
    outer.cellHealth = list.init2d(chunks.len*10, 13, 0)
    for c in chunks
        for x in range(0, 12)
            for y in range(0, (10*chunks.len)-chunkNum*10-1)
                tiles.setCell(x, y, c.baseTileIdx)
                cellHealth[y][x] = healthValues[c.baseTileIdx]
            end for
        end for
        tiles.scrollY = 640 * chunkNum
        disp.scrollY = 640 * chunkNum

        chunkNum += 1
        c.chunkNum = chunkNum
    end for
end function 

updateChunks = function
    for c in chunks
        c.update
    end for
end function

// ========= MINING =========

mouseWasPressed = false
tryMineOre = function
    if mouse.x <= 0 then return
    if mouse.x >= 960 then return
    if mouse.y <= 0 then return
    if mouse.y >= 640 then return

    if not mouse.button then 
        outer.mouseWasPressed = false
        return
    else if outer.mouseWasPressed == true then
        return
    end if
    outer.mouseWasPressed = true
    cellX = floor(mouse.x/64)
    cellY = floor((mouse.y + tiles.scrollY) /64)
    cell = tiles.cell(cellX, cellY) 

    if healthValues.hasIndex(cell) then mineOre(cellX, cellY, breakStrength + pickaxeUpgrade * 4)
end function

mineOre = function(cellX, cellY, damage)
    cell = tiles.cell(cellX, cellY)
    ore = oreValues[cell]
    cellHealth[cellY][cellX] -= damage

    particles.RockParticle.make cellX*64+32, cellY*64+32, 3, ore.color
    sound.hit.stop
    sound.hit.play
    sound.hit.adjust 1 * globals.soundVol, 0, mathUtil.randRange(0.9, 1.1)

    if cellHealth[cellY][cellX] > 0 then return false

    if cellAfterMinedValues.hasIndex(cell) then
        value = cellAfterMinedValues[cell]
        tiles.setCell(cellX, cellY, value)
        particles.OreParticle.make cellX*64+32, cellY*64+32, 6, ore.color
        sound.mine.stop
        sound.mine.play
        sound.mine.adjust 1 * globals.soundVol, 0, mathUtil.randRange(0.9, 1.1)
        if healthValues.hasIndex(value) then
            cellHealth[cellY][cellX] = healthValues[value]
        end if
    end if
    if oreValues.hasIndex(cell) then
        if ore.type == "random" then
            random = rnd
            if random < 0.4 then
                globals.coal += floor(rnd * 250)
            else if random < 0.6 then
                globals.copper += floor(rnd * 200)
            else if random < 0.8 then 
                globals.gold += floor(rnd * 50)
            else
                globals.diamond += floor(rnd * 15)
            end if
        else if ore.type == "crate" then
            globals.crates.push 1
        else if ore.type == "crate2" then
            globals.crates.push 2
        else if ore.type == "crate3" then
            globals.crates.push 3
        else
            multiplier = 1 + (globals.fortuneKeyOneCount / 20) + (globals.fortuneKeyTwoCount / 10) + (globals.fortuneKeyThreeCount / 4)
            globals[ore.type] += ore.amount * multiplier
        end if
        updateUI
    end if
    return true
end function

// ========= GAME LOOP =========

startTime = time

initChunks
initUI
updateUI

lastTime = time
while true
    yield
    dt = time - lastTime
    lastTime = time
    updatable.update dt
    textUI.update
    tryMineOre
    updateChunks
    //updateUI

    if currentChunk == -5 then break
end while

display(0).mode = displayMode.solidColor
d = display(0)
d.color = color.clear
for a in range(0, 255, 2)
    d.color = color.rgba(0, 0, 0, a)
    yield
end for

display(0).mode = displayMode.off
disp.clear
gfx.clear
tiles.extent = [15, 10]
tiles.clear 40

textUI.TextControl.instances = []

text.clear
text.color = color.white
textUtil.printCenteredAt 35, 24, "Thank you for playing!"
textUtil.printCenteredAt 35, 20, "This game was made for the"
textUtil.printCenteredAt 35, 19, "Micro Jam 23."

textUtil.printCenteredAt 35, 16, "You made it to the core!"
textUtil.printCenteredAt 35, 15, "Unfortunately, you are dead."

textUtil.printCenteredAt 35, 12, "You ended with:"
textUtil.printCenteredAt 35, 11, formatNumber(money) + " Money"
textUtil.printCenteredAt 35, 10, formatNumber(stone) + " Stone"
textUtil.printCenteredAt 35, 9, formatNumber(coal) + " Coal"
textUtil.printCenteredAt 35, 8, formatNumber(copper) + " Copper"
textUtil.printCenteredAt 35, 7, formatNumber(gold) + " Gold"
textUtil.printCenteredAt 35, 6, formatNumber(diamond) + " Diamond"

textUtil.printCenteredAt 35, 4, "And it took you: " + ceil(time - startTime) + " seconds."

restartButton = textUI.Button.make(25, 2, 19, "Play Again?")
restartButton.start
restartButton.action = function
    reset; run "main"
end function

for a in range(255, 0, -4)
    d.color = color.rgba(0, 0, 0, a)
    yield
end for

while true
    yield
    textUI.update
end while