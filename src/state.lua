local stateClass = {}

local metaClass = {__index = stateClass}

function stateClass:set(n : any)
	if self._typeprotection and type(n) ~= type(self._value) then
		error(string.format("%s isnt the same type as %s", n, self._value)) 
	elseif self._value ~= n then
		
		if #self._connections > 0 then
			for i, v in ipairs(self._connections) do
				task.spawn(v,self._value, n)
			end
		end
		
		self._value = n

	end
end

function stateClass:rawSet(n : any)
	self._value = n
end

function stateClass:get()
	return self._value
end

function stateClass:ListenToChanges(fn : (oldValue : any, newValue : any) -> ()) : number
	table.insert(self._connections, fn)
	return #self._connections
end

return function(Value : number, TypeProtection : boolean)
	return setmetatable({_connections = {},_value = Value, _typeprotection = TypeProtection}, metaClass)
end
