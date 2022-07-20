
local Stack = {}
local StackSize = 0

local weak_metatable = {__mode = "k"}

local function InitRelationSet(RelationFather) : number
	StackSize += 1
	Stack[StackSize] = {}
	Stack[StackSize][RelationFather] = true
	return StackSize
end

local function getRelatedsFromAddresses(setOfAddresses)
	local relateds = {}
	
	for _, address in ipairs(setOfAddresses) do
		if address > StackSize then
			break
		end
		
		for Member, isFather in pairs(Stack[address]) do
			if isFather == true then
				relateds[Member] = true

			end

			relateds[Member] = false
		end

	end
	
	return relateds
end


local function addToCurrentRelationSet(Object) : number
	Stack[StackSize][Object] = false

	return StackSize
end

local function removeFromAllRelationSets(Object) : nil
	for Index, RelationSet in ipairs(Stack) do
		if Index > StackSize then
			break
		end

		RelationSet[Object] = nil
	end
end

return {
	InitRelationSet = InitRelationSet,
	addToCurrentRelationSet = addToCurrentRelationSet,
	removeFromAllRelationSets = removeFromAllRelationSets,
	Stack = Stack,
	getRelatedsFromAddresses = getRelatedsFromAddresses
}
