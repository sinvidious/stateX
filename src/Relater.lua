--[[
  RelaterV2 is a brand new version of the Relater module in the StateX V0.3 version, which got refactored and heavilty tested.
]]


local Stack = {}
local StackSize = 0

local weak_metatable = {__mode = "k"}

local function InitRelationSet(RelationFather) : number
	StackSize += 1
	Stack[StackSize] = {}
	Stack[StackSize][RelationFather] = true
	return StackSize
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
	Stack = Stack
}
