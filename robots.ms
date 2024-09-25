
import "mathUtil"
// Node class: used internally to represent one step
// in the search process.
Node = {}
Node.neighbors = function
	return [
		{"x": self.position.x + 1, "y": self.position.y},
		{"x": self.position.x - 1, "y": self.position.y},
		{"x": self.position.x, "y": self.position.y + 1},
		{"x": self.position.x, "y": self.position.y - 1},
	]
end function

Node.make = function(position, endPos, parentNode = null)
	n = new Node
	n.position = {
		"x": position.x,
		"y": position.y,
	}
	n.parent = parentNode
	n.estCostToEnd = mathUtil.distance(n.position, endPos)
	n.estTotalCost = n.estCostToEnd
	n.costFromStart = 0
	if parentNode != null then
		n.costFromStart = parentNode.costFromStart + 1
	end if
	n.estTotalCost = n.costFromStart + n.estCostToEnd
	return n
end function

Node.path = function
	result = []
	n = self
	while n
		result.insert 0, n.position
		n = n.parent
	end while
	return result
end function

// Main entry point: Find a path between two positions,
// each specified as a map with "x" and "y" values.
find = function(startPos, endPos)
	toDoList = [ Node.make(startPos, endPos) ]
	doneSet = {}
	globals.hack = []
	while toDoList
		n = toDoList.pull
		if n.position.x == endPos.x and n.position.y == endPos.y then return n.path
		for pos in n.neighbors
			if doneSet.hasIndex(pos) then continue
			doneSet.push pos
			//t = here.tile(pos.x, pos.y)
			//if t != null and not t.passable then continue
			noob = Node.make(pos, endPos, n)
			if noob.costFromStart < 50 then toDoList.push noob
		end for
		toDoList.sort "estTotalCost"
	end while
end function

Robot = new UpdatableSprite
Robot.image = file.loadImage("pics/robo.png")
Robot.position = {}
Robot.facing = {}
Robot.scale = 4
Robot.path = []
Robot.y = 64 * 64
Robot.mining = false
Robot.chunkIndex = 0
Robot.mineTime = 0.8
Robot.minePower = 1
Robot.sellValue = 15
Robot.fuelTime = 30
Robot.fuelAmount = 1
Robot.speed = 250

Robot.lastMineTime = 0
Robot.lastFuelTime = 0

Robot.init = function
    super.init
    disp.sprites.push self
    self.position = {"x": 0, "y": (globals.chunks.len*10)+self.chunkIndex*10-1}
    self.facing = {"x": 0, "y": 0}
    self.checkPath
    self.localBounds = new Bounds
	self.localBounds.width = self.image.width
	self.localBounds.height = self.image.height
end function

Robot.die = function
    super.die
    disp.sprites.removeVal self
    particles.OreParticle.make self.position.x*64+32, self.position.y*64+32, 10, color.gray
end function

Robot.update = function(dt=0.0167)
    self.speedMultiplier = 1 + (globals.speedKeyOneCount / 10) + (globals.speedKeyTwoCount / 4) + (globals.speedKeyThreeCount / 2)
    if time > self.lastFuelTime + self.fuelTime then
        if globals.coal < self.fuelAmount then return
        globals.coal -= self.fuelAmount
        self.lastFuelTime = time
        globals.updateUI
    end if

    self.checkPath
    self.faceLoc self.path[0].x, self.path[0].y
    self.forward dt
    if mouse.button(1) and self.contains([mouse.x + disp.scrollX, mouse.y + disp.scrollY]) then
        self.die
        globals.money += self.sellValue
        globals.updateUI
        sound.machineSell.play
        sound.machineSell.adjust globals.soundVol
    end if
end function

Robot.goTo = function(x,y)
   dest = {"x":x, "y":y}
   self.path = find(self.position, dest)
end function

Robot.checkPath = function
    if self.mining == true then
        cellX = floor(self.x/64)
        cellY = floor(self.y/64)
        cell = tiles.cell(cellX, cellY) 
        if not healthValues.hasIndex(cell) then 
            self.mining = false
            return
        end if
        if time > self.lastMineTime + (self.mineTime / self.speedMultiplier) then
            self.lastMineTime = time
            mined = globals.mineOre(self.position.x, self.position.y, self.minePower)
            if mined == true then self.mining = false
        end if
        return
    end if

    if self.x == self.position.x*64+32 and self.y == self.position.y*64+32 then
        self.path.remove 0
    end if
    if self.path.len == 0 then 
        cellX = floor(self.x/64)
        cellY = floor(self.y/64)
        cell = tiles.cell(cellX, cellY) 

        if healthValues.hasIndex(cell) and oreValues.hasIndex(cell) then self.mining = true
        nextPath = self.getNextPath
        self.goTo nextPath[0], nextPath[1]
    end if
end function

Robot.getNextPath = function
    return [floor(rnd*12), floor(rnd*10)+(globals.chunks.len*10-10)+self.chunkIndex*10]
end function

Robot.forward = function(dt=0.0167)

    self.position.x = self.position.x + self.facing.x
    self.position.y = self.position.y + self.facing.y
    self.x = mathUtil.moveTowards(self.x, self.position.x*64+32, self.speed * self.speedMultiplier*dt)
    self.y = mathUtil.moveTowards(self.y, self.position.y*64+32, self.speed * self.speedMultiplier*dt)
    if self.facing.x > 0 then
        self.rotation = 0  // Facing right
    else if self.facing.x < 0 then
        self.rotation = 180  // Facing left
    else if self.facing.y > 0 then
        self.rotation = 90  // Facing up
    else if self.facing.y < 0 then
        self.rotation = 270  // Facing down
    end if
end function

Robot.faceLoc = function(targetX, targetY)
    // Calculate the direction to face towards the target position.
    deltaX = targetX - self.position.x
    deltaY = targetY - self.position.y
    
    // Normalize the direction and set rotation based on the facing direction
    if abs(deltaX) > abs(deltaY) then
        self.facing = {"x": sign(deltaX), "y": 0}  // Face horizontally
    else
        self.facing = {"x": 0, "y": sign(deltaY)}  // Face vertically
    end if
end function

LvlOneRobot = new Robot
LvlOneRobot.image = file.loadImage("pics/robo.png")
LvlOneRobot.position = {}
LvlOneRobot.facing = {}
LvlOneRobot.path = []

LvlOneRobot.mineTime = 0.7
LvlOneRobot.minePower = 2
LvlOneRobot.sellValue = 15
LvlOneRobot.fuelTime = 30
LvlOneRobot.fuelAmount = 1
LvlOneRobot.speed = 300

LvlTwoRobot = new Robot
LvlTwoRobot.image = file.loadImage("pics/robo2.png")
LvlTwoRobot.position = {}
LvlTwoRobot.facing = {}
LvlTwoRobot.path = []

LvlTwoRobot.mineTime = 0.4
LvlTwoRobot.minePower = 2
LvlTwoRobot.sellValue = 35
LvlTwoRobot.fuelTime = 20
LvlTwoRobot.fuelAmount = 3
LvlTwoRobot.speed = 300

LvlThreeRobot = new Robot
LvlThreeRobot.image = file.loadImage("pics/robo3.png")
LvlThreeRobot.position = {}
LvlThreeRobot.facing = {}
LvlThreeRobot.path = []

LvlThreeRobot.mineTime = 0.5
LvlThreeRobot.minePower = 4
LvlThreeRobot.sellValue = 75
LvlThreeRobot.fuelTime = 25
LvlThreeRobot.fuelAmount = 6
LvlThreeRobot.speed = 350

LvlFourRobot = new Robot
LvlFourRobot.image = file.loadImage("pics/robo4.png")
LvlFourRobot.position = {}
LvlFourRobot.facing = {}
LvlFourRobot.path = []

LvlFourRobot.mineTime = 0.15
LvlFourRobot.minePower = 4
LvlFourRobot.sellValue = 250
LvlFourRobot.fuelTime = 15
LvlFourRobot.fuelAmount = 3
LvlFourRobot.speed = 700

LvlFiveRobot = new Robot
LvlFiveRobot.image = file.loadImage("pics/robo5.png")
LvlFiveRobot.position = {}
LvlFiveRobot.facing = {}
LvlFiveRobot.path = []

LvlFiveRobot.mineTime = 0.2
LvlFiveRobot.minePower = 15
LvlFiveRobot.sellValue = 1000
LvlFiveRobot.fuelTime = 5
LvlFiveRobot.fuelAmount = 30
LvlFiveRobot.speed = 600

WiperRobot = new Robot
WiperRobot.image = file.loadImage("pics/wiper.png")
WiperRobot.position = {}
WiperRobot.facing = {}
WiperRobot.path = []

WiperRobot.mineTime = 0.5
WiperRobot.minePower = 4
WiperRobot.sellValue = 75
WiperRobot.fuelTime = 25
WiperRobot.fuelAmount = 6
WiperRobot.speed = 450
WiperRobot.lastPos = {}

WiperRobot.init = function
    self.lastPos = {"x": 0, "y": (globals.chunks.len*10)+self.chunkIndex*10-1}
    super.init 
end function

WiperRobot.forward = function(dt=0.0167)
    super.forward dt
    self.lastPos.x = self.position.x
    self.lastPos.y = self.position.y
end function

WiperRobot.getNextPath = function
    if self.lastPos.x == 12 then
        self.lastPos.x = -1
        self.lastPos.y -= 1
    end if
    if self.lastPos.y == -1 + (globals.chunks.len*10-10) + self.chunkIndex*10 then
        self.lastPos.y = 9 + (globals.chunks.len*10-10) + self.chunkIndex*10
    end if
    return [
        self.lastPos.x+1, 
        self.lastPos.y,
        ]
end function