
local ScriptSignal = {}
ScriptSignal.__index = ScriptSignal

local ScriptConnection = {}
ScriptConnection.__index = ScriptConnection


export type Class = typeof( setmetatable({
	_active = true,
	_head = nil :: ScriptConnectionNode?
}, ScriptSignal) )

export type ScriptConnection = typeof( setmetatable({
	Connected = true,
	_node = nil :: ScriptConnectionNode?
}, ScriptConnection) )

type ScriptConnectionNode = {
	_signal: Class,
	_connection: ScriptConnection?,
	_handler: (...any) -> (),

	_next: ScriptConnectionNode?,
	_prev: ScriptConnectionNode?
}


function ScriptSignal.new(): Class
	return setmetatable({
		_active = true,
		_head = nil
	}, ScriptSignal)
end

function ScriptSignal.Is(object): boolean
	return typeof(object) == 'table'
		and getmetatable(object) == ScriptSignal
end


function ScriptSignal:IsActive(): boolean
	return self._active == true
end

function ScriptSignal:Connect(
	handler: (...any) -> ()
): ScriptConnection

	assert(
		typeof(handler) == 'function',
		"Must be function"
	)

	if self._active ~= true then
		return setmetatable({
			Connected = false,
			_node = nil
		}, ScriptConnection)
	end

	local _head: ScriptConnectionNode? = self._head

	local node: ScriptConnectionNode = {
		_signal = self :: Class,
		_connection = nil,
		_handler = handler,

		_next = _head,
		_prev = nil
	}

	if _head ~= nil then
		_head._prev = node
	end

	self._head = node

	local connection = setmetatable({
		Connected = true,
		_node = node
	}, ScriptConnection)

	node._connection = connection

	return connection :: ScriptConnection
end


function ScriptSignal:Once(
	handler: (...any) -> ()
): ScriptConnection

	assert(
		typeof(handler) == 'function',
		"Must be function"
	)

	local connection
	connection = self:Connect(function(...)
		if connection == nil then
			return
		end

		connection:Disconnect()
		connection = nil

		handler(...)
	end)

	return connection
end
ScriptSignal.ConnectOnce = ScriptSignal.Once


function ScriptSignal:Wait(): (...any)
	local thread do
		thread = coroutine.running()

		local connection
		connection = self:Connect(function(...)
			if connection == nil then
				return
			end

			connection:Disconnect()
			connection = nil

			task.spawn(thread, ...)
		end)
	end

	return coroutine.yield()
end


function ScriptSignal:Fire(...: any)
	local node: ScriptConnectionNode? = self._head
	while node ~= nil do
		task.defer(node._handler, ...)

		node = node._next
	end
end


function ScriptSignal:DisconnectAll()
	local node: ScriptConnectionNode? = self._head
	while node ~= nil do
		local _connection = node._connection

		if _connection ~= nil then
			_connection.Connected = false
			_connection._node = nil
			node._connection = nil
		end

		node = node._next
	end

	self._head = nil
end


function ScriptSignal:Destroy()
	if self._active ~= true then
		return
	end

	self:DisconnectAll()
	self._active = false
end


function ScriptConnection:Disconnect()
	if self.Connected ~= true then
		return
	end

	self.Connected = false

	local _node: ScriptConnectionNode = self._node
	local _prev = _node._prev
	local _next = _node._next

	if _next ~= nil then
		_next._prev = _prev
	end

	if _prev ~= nil then
		_prev._next = _next
	else
		-- _node == _signal._head

		_node._signal._head = _next
	end

	_node._connection = nil
	self._node = nil
end
ScriptConnection.Destroy = ScriptConnection.Disconnect

return ScriptSignal
