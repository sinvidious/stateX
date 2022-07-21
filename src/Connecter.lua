local Stack = {}
local StackSize = {size = 0}

local function InitRelationFather (RelationFather)
	table.insert(Stack, RelationFather)
	StackSize.size += 1

	return StackSize.size
end

local function bindToLatestRelationFather(Object)
	local CurrentFather = Stack[StackSize.size]

	if Object == CurrentFather  or Object._fathers[CurrentFather] ~= nil  then return end

	Object._fathers[CurrentFather] = true
end

return {
	InitRelationFather = InitRelationFather,
	bindToLatestRelationFather = bindToLatestRelationFather,
	stacksize = StackSize
}