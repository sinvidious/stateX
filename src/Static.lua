local ForkSignal = require(script.Parent.ForkSignal)
local Connecter = require(script.Parent.Connecter)
local initRelationFather = Connecter.InitRelationFather
local BindToLatestRelationFather = Connecter.bindToLatestRelationFather
-----------------------------------------------------------------------

export type StaticState = {
	_signal : RBXScriptSignal,
	_value : any,
	_typeprotect : boolean,
	_fathers : {}
}


local class  = {}
local meta = {__index = class}

function class:rawset(input)
	self._value = input

	for Father in pairs(self._fathers) do
		Father:update()
	end
end

function class:set(input)
	local oldValue = self._value
	
	local oldValueType = typeof(oldValue)
	local newValueType = typeof(input)
	if self._typeprotect and oldValueType ~=newValueType then
		error(string.format("%s (%s) is not the same type as %s (%s)", self._value, oldValueType, input, newValueType))
		
	elseif self._value ~= input then
		
		self:rawset(input)
		
		self._signal:Fire(oldValue, self._value)
	
	end
end

function class:get(asRelation : boolean?)
	if asRelation ~= false then
		BindToLatestRelationFather(self)
	end
	
	return self._value
end

function class:onchange(func : (oldValue : any, nowValue : any) -> ())
	local self : StaticState = self
	
	return self._signal:Connect(func)
end

-----------------------------------------------------------------------
return function(value, typeprotect)
	local self = setmetatable({
		_signal = ForkSignal.new(),
		_value = value,
		_typeprotect = typeprotect,
		_fathers = {}
	},meta)
	
	return self

end