// Event-driven text user interface elements.
import "chars"

import "events"
KeyHandler = @events.KeyHandler
eventLoop = @events.eventLoop

import "textUtil"
textCol = @textUtil.textCol
textRow = @textUtil.textRow

_savedColors = []  // list of [color, backColor]
saveColors = function
	_savedColors.push [text.color, text.backColor]
end function

restoreColors = function
	colors = _savedColors.pop
	text.color = colors[0]
	text.backColor = colors[1]
end function

setCell = function(col, row, character, foreColor=null, backColor=null)
	// Set the given cell, but ALSO apply the given or current colors.
	text.setCell col, row, character
	if foreColor != null then
		text.setCellColor col, row, foreColor
	else if text.inverse then
		text.setCellColor col, row, text.backColor
	else
		text.setCellColor col, row, text.color
	end if
	if backColor != null then
		text.setCellBackColor col, row, backColor
	else if text.inverse then
		text.setCellBackColor col, row, text.color
	else
		text.setCellBackColor col, row, text.backColor
	end if
end function

//----------------------------------------------------------------------
// TextArea: represents a rectangular area on the text screen.
TextArea = {}
TextArea.fromRow = 0
TextArea.toRow = 25
TextArea.fromCol = 0
TextArea.toCol = 67

TextArea.make = function(fromCol, toCol, fromRow, toRow=null)
	if toRow == null then toRow == fromRow
	noob = new self
	noob.fromCol = fromCol; noob.toCol = toCol
	noob.fromRow = fromRow; noob.toRow = toRow
	return noob
end function

TextArea.rowRange = function; return range(self.fromRow, self.toRow); end function
TextArea.colRange = function; return range(self.fromCol, self.toCol); end function
TextArea.height = function; return self.toRow - self.fromRow + 1; end function
TextArea.width  = function; return self.toCol - self.fromCol + 1; end function

TextArea.containsColRow = function(col, row)
	return self.fromCol <= col <= self.toCol and
	       self.fromRow <= row <= self.toRow
end function

TextArea.containsXY = function(xOrXYMap, y=null)
	if xOrXYMap isa map then
		x = xOrXYMap.x
		y = xOrXYMap.y
	else
		x = xOrXYMap
	end if
	return self.containsColRow(textCol(x), textRow(y))
end function

TextArea.fill = function(fillChar="•")
	columns = self.width
	rowFill = (fillChar * columns)[:columns]
	for row in range(self.toRow, self.fromRow, -1)
		text.row = row; text.column = self.fromCol
		print rowFill, ""
	end for
	text.column = 0
end function

TextArea.containsMouse = function; return self.containsXY(mouse); end function

//----------------------------------------------------------------------
// TextControl: represents a UI control on the text screen.
TextControl = new TextArea
TextControl.instances = []
TextControl.hitBy = function(xyPos)
	for i in range(TextControl.instances.len-1, 0, -1)
		tc = TextControl.instances[i]
		if tc.get("ignoreClicks", false) then continue
		if tc.containsXY(xyPos) then return tc
	end for
	return null
end function

TextControl.onKey = new KeyHandler
TextControl.onKeyDown = new KeyHandler
TextControl.onKeyDown.mode = 0
TextControl.onKeyUp = new KeyHandler
TextControl.onKeyUp.mode = 2
TextControl.onClick = null
TextControl.onRightClick = null
TextControl.onDrag = null
TextControl.onDragEnd = null
TextControl.onMouseOver = null
TextControl.onMouseExit = null
TextControl.update = null

TextControl._dragging = false
TextControl.ignoreClicks = false
TextControl.joystick = "any" // or, assign 1 through 29

TextControl.make = function(fromCol, toCol, fromRow, toRow=null)
	return super.make(fromCol, toCol, fromRow, toRow)
end function

TextControl._update = function
	self.update
	self.onKey._check self
	self.onKeyUp._check self
	self.onKeyDown._check self
end function

// Simple state machine support.  Basically just gives you
// a place to add code when you change states via spr.enterState.
TextControl.state = ""
TextControl.stateStartTime = time
TextControl.timeInState = function
	return time - self.stateStartTime
end function
TextControl.onEnterState = function(newState); end function
TextControl.onExitState = function(toNewState); end function
TextControl.enterState = function(newState)
	if newState == self.state then return
	self.onExitState newState
	self.onEnterState newState
	self.state = newState
	self.stateStartTime = time
end function

TextControl.start = function
	TextControl.instances.push self
end function

TextControl.stop = function
	while true
		idx = TextControl.instances.indexOf(self)
		if idx == null then break
		TextControl.instances.remove idx
	end while
end function

//----------------------------------------------------------------------
// Button: a clickable button with an "action" method that runs when clicked.
Button = new TextControl
Button.normalColor = "#CCCCCC"
Button.hoverColor = "#CCCCFF"
Button.pressedColor = "#8888AA"
Button.caption = "   "
Button.action = null  // Hook up your button action here!

Button.make = function(column, row, width=12, caption="", action=null)
	noob = super.make(column, column+width-1, row, row)
	noob.caption = caption
	if @action != null then noob.action = @action
	return noob
end function

Button.start = function
	super.start
	self.draw
end function

Button.stop = function
	super.stop
	textUtil.clearRect self.fromCol, self.fromRow, self.width*1, 1
end function

Button.draw = function(color = null)
	idx = TextControl.instances.indexOf(self)
	if idx == null then return
	if color == null then color = self.normalColor
	paddedCaption = " " * (self.width - 2 - self.caption.len)/2 +
	   self.caption + " " * self.width
	paddedCaption = paddedCaption[:self.width-2]
	text.row = self.fromRow; text.column = self.fromCol
	saveColors
	text.color = color
	text.inverse = true
	print chars.buttonCapLeft + paddedCaption, ""
	setCell self.toCol, self.fromRow, chars.buttonCapRight
	text.inverse = false
	text.column = 0
	restoreColors
end function

Button.onMouseOver = function
	self.draw self.hoverColor
end function

Button.onMouseExit = function
	self.draw self.normalColor
end function

Button.onDrag = function
	if self.containsXY(mouse) then
		self.draw self.pressedColor
	else
		self.draw self.normalColor
	end if
end function

Button.onDragEnd = function
	if self.containsXY(mouse) then
		self.draw self.normalColor
		self.action
	end if	
end function

//----------------------------------------------------------------------
// Switch: a slider switch.  Knob to the right is "on"; left is "off".
Switch = new TextControl
Switch.knobColor = "#CCCCCC"
Switch.hoverColor = "#CCCCFF"
Switch.onColor = "#00CC00"
Switch.offColor = "#666666"
Switch.action = function(nowOn); end function
Switch.isOn = 0  // any value from 0-1 is acceptable

Switch.make = function(column, row, action=null)
	noob = super.make(column, column+3, row, row)
	if @action != null then noob.action = @action
	return noob
end function

Switch.start = function
	super.start
	self.draw
end function

Switch.draw = function(knobColor=null)
	if knobColor == null then knobColor = self.knobColor
	x = self.fromCol
	y = self.fromRow
	
	if self.isOn < 0.33 then		// switch off
		setCell x, y, chars.buttonCapLeft, text.backColor, knobColor
		setCell x+1, y, chars.buttonCapRight, self.offColor, knobColor
		setCell x+2, y, " ", text.backColor, self.offColor
		setCell x+3, y, chars.buttonCapRight, text.backColor, self.offColor
	else if self.isOn < 0.66 then   // switch middle
		setCell x, y, chars.buttonCapLeft, text.backColor, self.onColor
		setCell x+1, y, chars.buttonCapLeft, self.onColor, knobColor
		setCell x+2, y, chars.buttonCapRight, self.offColor, knobColor
		setCell x+3, y, chars.buttonCapRight, text.backColor, self.offColor
	else                            // switch on
		setCell x, y, chars.buttonCapLeft, text.backColor, self.onColor
		setCell x+1, y, " ", text.backColor, self.onColor
		setCell x+2, y, chars.buttonCapLeft, self.onColor, knobColor
		setCell x+3, y, chars.buttonCapRight, text.backColor, knobColor
	end if
end function

Switch.onMouseOver = function
	self.draw self.hoverColor
end function

Switch.onMouseExit = function
	self.draw self.knobColor
end function

Switch.toggle = function
	if self.isOn then
		states = [0.5, 0]
	else
		states = [0.5, 1]
	end if
	self.isOn = states[0]
	self.draw self.hoverColor
	wait 0.05
	self.isOn = states[1]
	if self.containsXY(mouse) then c = self.hoverColor else c = self.knobColor
	self.draw c
	self.action self.isOn
end function

Switch.set = function(newValue)
	self.isOn = newValue
	self.draw
	self.action self.isOn
end function

Switch.onClick = @Switch.toggle

//----------------------------------------------------------------------
// Slider: a knob what can slide back and forth to select a value.
Slider = new TextControl
Slider.knobColor = "#CCCCCC"
Slider.hoverColor = "#CCCCFF"
Slider.trackColor = "#666666"	// (track background color)
Slider.dashColor = "#444444"	// (dashes drawn on the track)
Slider.action = function(nowOn); end function
Slider.value = 0
Slider.minValue = 0
Slider.maxValue = 1

Slider.make = function(column, row, width=11, action=null)
	noob = super.make(column, column+width-1, row, row)
	if @action != null then noob.action = @action
	return noob
end function

Slider.start = function
	super.start
	self.draw
end function

Slider.draw = function(knobColor=null)
	if knobColor == null then knobColor = self.knobColor
	t = (self.value - self.minValue) / (self.maxValue - self.minValue)
	knobPos = round(t * (self.width - 2))
	y = self.fromRow
	for x in range(self.fromCol, self.fromCol + knobPos-1, 1)
		setCell x, y, "-", self.dashColor, self.trackColor
	end for
	setCell self.fromCol + knobPos, y, chars.buttonCapLeft, 
	  self.trackColor, knobColor
	setCell self.fromCol + knobPos + 1, y, chars.buttonCapRight, 
	  self.trackColor, knobColor
	for x in range(self.fromCol + knobPos + 2, self.toCol, 1)
		setCell x, y, "-", self.dashColor, self.trackColor
	end for
end function

Slider.onMouseOver = function
	self.draw self.hoverColor
end function

Slider.onMouseExit = function
	self.draw self.knobColor
end function

Slider.onDrag = function
	col = textUtil.textCol(mouse.x)
	t = (col - self.fromCol) / (self.width - 1)
	if t < 0 then t = 0; if t > 1 then t = 1
	newValue = self.minValue + (self.maxValue - self.minValue) * t
	if newValue != self.value then
		self.value = newValue
		self.draw self.hoverColor
		self.action newValue
	end if
end function

Slider.set = function(newValue)
	self.value = newValue
	if self.containsXY(mouse) then c = self.hoverColor else c = self.knobColor
	self.draw c
	self.action newValue
end function

//----------------------------------------------------------------------

dragging = null
lastMouseOver = null
mouseWasDown = false

update = function
	for tc in TextControl.instances
		tc._update
	end for
	if mouse.button then
		if not mouseWasDown then
			// initial click: find sprite, start drag
			outer.dragging = TextControl.hitBy(mouse)
			if dragging then dragging.onClick
			outer.mouseWasDown = true
		else
			// subsequent frames: continue the drag
			if dragging then dragging.onDrag
		end if
	else if mouseWasDown then
		// was down, but no longer is; stop dragging
		if dragging then
			dragging.onDragEnd
			outer.dragging = null
		end if
		outer.mouseWasDown = false
	else
		// mouse isn't down, and wasn't before either; just do mouse-over
		mouseOver = TextControl.hitBy(mouse)
		if mouseOver != lastMouseOver then
			if mouseOver then mouseOver.onMouseOver
			if lastMouseOver then lastMouseOver.onMouseExit
			outer.lastMouseOver = mouseOver
		end if
	end if
	if mouse.button(1) then
		hit = TextControl.hitBy(mouse)
		if hit then hit.onRightClick
	end if
end function

updateHook = function
	update
	events.eventLoop.doAfter 0.01, @updateHook
end function

runEventLoop = function(eventLoop = null)
	if eventLoop == null then eventLoop = events.eventLoop
	outer.eventLoop = eventLoop
	updateHook
	eventLoop.run
end function

demo = function
	clear
	textUtil.printAt 39, 23, "TextControl:"
	outer.box = TextControl.make(40, 49, 18, 22)
	box.start
	box.fill
	box.onMouseOver = function
		text.color = color.white
		self.fill
		text.color = color.orange
	end function
	box.onMouseExit = function
		text.color = color.orange
		self.fill
	end function
	
	box.clearMsgTime = null
	box.showMessage = function(msg, duration=1)
		cols = self.width
		paddedMsg = (" " * (cols - msg.len)/2 + msg + " " * cols)[:cols]
		textUtil.printAt box.fromCol, box.fromRow - 1, paddedMsg
		self.clearMsgTime = time + duration
	end function
	box.update = function
		if self.clearMsgTime and time > self.clearMsgTime then
			self.showMessage ""
			self.clearMsgTime = null
		end if
	end function

	box.onClick = function
		self.showMessage "Click!"
	end function
	
	outer.quitBtn = Button.make(60, 0, 8, "Exit")
	quitBtn.action = function; eventLoop.stop; text.row = 25; end function
	quitBtn.start
	
	textUtil.printAt 12, 22, "Switch:"
	outer.switch = Switch.make(20, 22)
	switch.action = function(x); textUtil.printAt 25, 22, x; end function
	switch.start
	
	textUtil.printAt 12, 19, "Slider:"
	outer.slider = Slider.make(13, 18)
	slider.action = function(x); textUtil.printAt 25, 18, x + " "*8; end function
	slider.maxValue = 10
	slider.start
	
	outer.btn = Button.make(29, 20, 7, "Reset")
	btn.start
	btn.action = function
		switch.set false
		slider.set 0
	end function
	
	runEventLoop
end function

if locals == globals then demo
