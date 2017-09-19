-- collision definitions

local collisionslib = {}

local categoryNames = {}
local categoryCounter = 1

local function newCategory( name )
	categoryNames[ name ] = categoryCounter
	categoryCounter = categoryCounter * 2
	return categoryNames[ name ]
end

local function getCategory( name )
	local category = categoryNames[ name ]
	if (category == nil) then
		category = newCategory( name )
	end
	return category
end
collisionslib.getCategory = getCategory

local function getMask( ... )
	local mask = 0
	for i=1, #arg do
		local name = arg[i]
		mask = mask + getCategory( name )
	end
	return mask
end
collisionslib.getMask = getMask


-- basic shape collisions with each other and scenery
collisionslib.shapeCollisionFilter = { categoryBits = getCategory("shapes"), maskBits = getMask("shapes","scenery") }

-- connecting links with each other only
collisionslib.linkCollisionFilter = { categoryBits = getCategory("links"), maskBits = getMask("links") }

-- scenery collides with basic shapes only
collisionslib.sceneryCollisionFilter = { categoryBits = getCategory("scenery"), maskBits = getMask("shapes") }

-- composite shape internals collide with nothing
collisionslib.flexCollisionFilter = { categoryBits = getCategory("flex"), maskBits = 0 }

collisionslib.engineCollisionFilter = { categoryBits = getCategory("engine"), maskBits = getMask("scenery","shapes","engine") }
collisionslib.beamCollisionFilter = { categoryBits = getCategory("beam"), maskBits = getMask("scenery","shapes","cog","beam","wheel","switch") }
collisionslib.cogCollisionFilter = { categoryBits = getCategory("cog"), maskBits = getMask("scenery","shapes","beam","cog","wheel","switch") }
collisionslib.wheelCollisionFilter = { categoryBits = getCategory("wheel"), maskBits = getMask("scenery","shapes","beam","cog","wheel","switch") }
collisionslib.switchCollisionFilter = { categoryBits = getCategory("switch"), maskBits = getMask("scenery","shapes","beam","cog","wheel","switch") }

collisionslib.pivotMagnetCollisionFilter = { categoryBits = getCategory("pivot-magnet"), maskBits = getMask("pivot-magnet", "motor-magnet") }
collisionslib.motorMagnetCollisionFilter = { categoryBits = getCategory("motor-magnet"), maskBits = getMask("pivot-magnet") }
collisionslib.socketMagnetCollisionFilter = { categoryBits = getCategory("socket-magnet"), maskBits = getMask("plug-magnet") }
collisionslib.plugMagnetCollisionFilter = { categoryBits = getCategory("plug-magnet"), maskBits = getMask("socket-magnet") }

return collisionslib
