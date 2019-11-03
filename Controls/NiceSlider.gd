extends Control

var sliderPositon
var sliderLastPosition

var lastMovingStepTime = OS.get_ticks_msec()
var speedSetTime =  OS.get_ticks_msec()

var MIN_SENSITIVITY = 1
var MAX_SENSITIVITY = 100
var sensitivity = self.MAX_SENSITIVITY

var inernalValue = 0
var value = 0
var minValue = 0
var maxValue = 100

var speed = 0
var MAX_SPEED = 1000
var SPEED_DECREMENT = 2


signal value_changed(value)

var isPressed = false

func _ready():
	sliderPositon = int((rect_size.y / 2))
	sliderLastPosition = null


func _gui_input(event):
	if event.is_class('InputEventScreenTouch'):
		accept_event()
		if (!event.pressed && OS.get_ticks_msec() - self.speedSetTime > 100):
			self.speed = 0 # discard speed becouse no swip
		 
		self.isPressed = event.pressed
		self.sliderLastPosition = null
		if self.isPressed:
			stop()
	
	if event.is_class('InputEventScreenDrag'):
		accept_event()
		move_manualy(event.position.y)
		set_new_speed(event.speed.y)


# warning-ignore:unused_argument
func _process(delta):
	if is_moving_automaticaly():
		move_step_automaticaly()


func _draw():
	var offset = 100
	var color
	if is_on_limit() :
		color = Color.gray
	else:
		color = Color.white
	
	# draw below sliderPosition
	var y = sliderPositon
	while(y < rect_size.y):
		draw_rect(Rect2(Vector2(0,y), Vector2(rect_size.x, 10)), color)
		y += offset
	
	# draw above sliderPositin
	y = sliderPositon
	while(y > 0):
		draw_rect(Rect2(Vector2(0,y), Vector2(rect_size.x, 10)), color)
		y -= offset
	
	# draw bounding box
	draw_rect(Rect2(Vector2(0,0), Vector2(rect_size.x, rect_size.y)), Color.white, false)


func move_manualy(fingerPosition):
	if self.sliderLastPosition == null :
		self.sliderLastPosition = fingerPosition
		self.sliderPositon = fingerPosition
		return
	
	var movedDistance = int(self.sliderLastPosition - fingerPosition)
	var allowedDecrement = self.update_value(movedDistance)
	#print(self.sliderLastPosition, ', ', event.position.y, ', ', movedDistance, ',', allowedDecrement)
	self.sliderPositon -= allowedDecrement
	self.sliderLastPosition = self.sliderPositon
	update()


func move_step_automaticaly():
	if !self.is_moving_in_current_direction_allowed():
		stop()
		return
	
	var currentTime = OS.get_ticks_msec()
	var elapsedTime = currentTime - self.lastMovingStepTime
	var delayMs = 1000.0 / abs(speed)
	if elapsedTime < delayMs :
		return
		
	self.lastMovingStepTime = currentTime
	update_values(elapsedTime / 1000.0)
	update()


func update_values(elapsedTime):
	var distanceToMove = int(self.speed * elapsedTime)
	self.speed -= self.SPEED_DECREMENT * self.speed/abs(self.speed)
	self.sliderPositon += distanceToMove
	flipSliderPositionIfNecessary()
	update_value(-distanceToMove)


func flipSliderPositionIfNecessary():
	if sliderPositon < 0 :
		sliderPositon = rect_size.y
		
	if sliderPositon > rect_size.y :
		sliderPositon = 0


func update_value(requestedIncrement):
	if abs(requestedIncrement) < 1 :
		return 0
	
	var successfullIncrement = 0
	var direction = int(requestedIncrement / abs(requestedIncrement))
	
	# warning-ignore:unused_variable
	for i in range(abs(requestedIncrement)):
		# print(direction, ',', self.value)
		if direction > 0 && self.value >= self.maxValue || direction < 0 && self.value <= self.minValue:
			stop()
			break
		
		self.inernalValue += 1 * direction
		successfullIncrement += 1 * direction
		
		if int(self.inernalValue) % self.sensitivity == 0 || self.is_on_limit() :
			self.value += 1 * direction
			emit_signal("value_changed", value)
	
	return successfullIncrement


func is_moving_automaticaly():
	return !isPressed && abs(self.speed) > SPEED_DECREMENT


func is_moving_in_current_direction_allowed():
	var direction = self.get_direction()
	return direction < 0 && self.value < self.maxValue || direction > 0 && self.value > self.minValue


func is_on_limit():
	return self.value >= self.maxValue || self.value <= self.minValue

func stop():
	self.speed = 0


func get_direction():
	return self.speed / abs(self.speed)


func set_new_speed(newSpeed):
	var s = abs(newSpeed)
	var direction =  newSpeed / s
	if s > self.MAX_SPEED :
		self.speed = self.MAX_SPEED * direction
	#elif s < self.MIN_SPEED :
	#	self.speed = 0
	else:
		self.speed = newSpeed
	
	self.speedSetTime =  OS.get_ticks_msec()


func get_min():
	return self.minValue


func set_min(minValue):
	self.minValue = minValue


func get_max():
	return self.maxValue


func set_max(maxValue):
	self.maxValue = maxValue


func get_value():
	return self.value


func set_value(value):
	if value < self.minValue :
		self.value = minValue
		self.inernalValue = self.value
		return
	
	if value > self.maxValue :
		self.value = self.maxValue
		self.inernalValue = self.value
		return
	
	self.value = int(value)
	self.inernalValue = int(value)
	self.inernalValue = int(self.inernalValue)


func set_sensitivity(sensitivity):
	if sensitivity > self.MAX_SENSITIVITY :
		self.sensitivity = self.MAX_SENSITIVITY
		return 
	
	if sensitivity < self.MIN_SENSITIVITY :
		self.sensitivity = self.MIN_SENSITIVITY
		return
	
	self.sensitivity = sensitivity