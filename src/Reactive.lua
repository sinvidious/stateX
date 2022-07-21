local ForkSignal = require(script.Parent.ForkSignal)
local Connecter = require(script.Parent.Connecter)
local initRelationFather = Connecter.InitRelationFather
local BindToLatestRelationFather = Connecter.bindToLatestRelationFather
-----------------------------------------------------------------------

export type ReactiveState = {
	_callback : () -> (...any),
	set : (...any) -> (),
	_signal : RBXScriptSignal,
	_value : any,
	_fathers : {}
}


local class  = {}
local meta = {__index = class}

function class:update()
	
	for Father in pairs(self._fathers) do
		Father:update()
	end
	
	local oldValue = self._value
	local nowValue = self._callback()
	
	self._value = nowValue
	
	self._signal:Fire(oldValue, nowValue)
	
end

function class:get(asRelation : boolean?)
	if asRelation ~= false then
		BindToLatestRelationFather(self)
	end
	
	return self._value
end

function class:onchange(func : (oldValue : any, nowValue : any) -> ())
	local self : ReactiveState = self
	
	return self._signal:Connect(func)
end


-----------------------------------------------------------------------
return function(getComputation, SetComputation)
	local self = setmetatable({
		_callback = getComputation,
		set = SetComputation,
		_signal = ForkSignal.new(),
		_value = "none",
		_fathers = {}
	},meta)
	
	Connecter.InitRelationFather(self)
	self:update()
	
	return self
end