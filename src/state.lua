local stateClass = {}

local metaClass = {__index = stateClass}

function stateClass:set(Value : any)
	if self._typeprotection and type(n) ~= type(self._value) then
		error(string.format("%s isnt the same type as %s", n, self._value)) 
	elseif self._value ~= n then

		if #self._connections > 0 then
			for i, v in ipairs(self._connections) do
				task.spawn(
					v, true, nil, self._value, n
				)
			end
		end

		self._value = n

	end
end

function stateClass:setKey(Key : any, value : any)
	local statewithKey = self._value[Key]
	if self._typeprotection and (type(self._value) ~= "table") or type(value) ~= type(statewithKey)  then
		error(string.format("Type protection: state is %s, oldValue is %s, value is %s ", type(self._value), type(statewithKey), type(value) ))
		
	elseif statewithKey ~= value then
		if #self._connections > 0 then
			for i, v in ipairs(self._connections) do
				task.spawn(
					v,false, Key, statewithKey, value
				)
			end
		end
		
		self._value[Key] = value

	end
end

function stateClass:rawSet(input : any)
	self._value = n
end

function stateClass:rawSetKey(Key : any, Value : any)
	self._value[Key] = Value
end

function stateClass:get()
	return self._value
end

function stateClass:ListenToStateChanges(fn : (isState : boolean, Key : any ,oldValue : any, newValue : any) -> ()) : number
	table.insert(self._connections, fn)
	return #self._connections
end


return function(Value : number, TypeProtection : boolean)
	return setmetatable({_connections = {},_value = Value, _typeprotection = TypeProtection}, metaClass)
end
