
RockParticle = new UpdatableSprite
RockParticle.image = file.loadImage("pics/stone.png")
RockParticle.stopTime = 0.3
RockParticle.lifeTime = 0.6
RockParticle.angle = 0
RockParticle.speed = 300
RockParticle.scale = 4
RockParticle.decel = 700

RockParticle.spawnTime = 0

RockParticle.init = function
    disp.sprites.insert 0, self
    super.init
    self.spawnTime = time
    rotations = [0, 90, 180, 270]
    self.rotation = rotations[rnd*rotations.len]
end function

RockParticle.die = function
    disp.sprites.removeVal self
    super.die
end function

RockParticle.update = function(dt=0.0167)
    elapsed = time - self.spawnTime
    stoptimeFraction = elapsed / self.stopTime

    dx = cos(self.angle)
    dy = sin(self.angle)
    self.x += dx * self.speed * dt
    self.y += dy * self.speed * dt

    if elapsed > self.stopTime then 
        if elapsed > self.lifeTime then self.die
    else
        self.scale = 5 - (stoptimeFraction * 2.5)
    end if
    self.speed = mathUtil.moveTowards(self.speed, 0, self.decel*dt)
end function

RockParticle.make = function(x, y, amount, tint)
    for i in range(1, amount)
        particle = new RockParticle
        particle.x = x; particle.y = y
        particle.tint = tint
        particle.angle = (i / amount) * 2 * pi 
        particle.angle += rnd * (90 * pi / 180)
        particle.init
    end for
end function

OreParticle = new RockParticle
OreParticle.image = file.loadImage("pics/ore.png")
OreParticle.stopTime = 0.3
OreParticle.lifeTime = 0.6
OreParticle.angle = 0
OreParticle.speed = 500
OreParticle.scale = 4
OreParticle.decel = 1500

OreParticle.make = function(x, y, amount, tint)
    for i in range(1, amount)
        particle = new OreParticle
        particle.x = x; particle.y = y
        particle.tint = tint
        particle.angle = (i / amount) * 2 * pi 
        particle.angle += rnd * (180 * pi / 180)
        particle.speed *= mathUtil.randRange(0.75, 1.25)
        particle.init
    end for
end function


SparkleParticle = new UpdatableSprite
SparkleParticle.image = file.loadImage("pics/sparkle.png")
SparkleParticle.lifeTime = 0.6
SparkleParticle.scale = 4

SparkleParticle.spawnTime = 0

SparkleParticle.init = function
    disp.sprites.insert 0, self
    super.init
    self.spawnTime = time
    rotations = [0, 90, 180, 270]
    self.rotation = rotations[rnd*rotations.len]
end function

SparkleParticle.die = function
    disp.sprites.removeVal self
    super.die
end function

SparkleParticle.update = function(dt=0.0167)
    elapsed = time - self.spawnTime
    lifetimeFraction = elapsed / self.lifeTime

    self.scale = 5 - (lifetimeFraction * 3.5)
    if elapsed > self.lifeTime then self.die
end function

SparkleParticle.make = function(x, y, amount, tint)
    for i in range(1, amount)
        particle = new SparkleParticle
        particle.x = x; particle.y = y
        particle.tint = tint
        particle.init
    end for
end function