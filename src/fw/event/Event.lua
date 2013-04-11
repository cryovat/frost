--- Represents a scriptable event. The event is realized as a @{coroutine}
-- running in a @{Sandbox}ed environment. The event script can write primitive
-- values to a persistent store (@{string}s, numbers and booleans) and can
-- call functions that the host environment provides to it.

Event = {}

function Event.new(o)
   o = o or {}
   setmetatable(o, Event)
   Event.__index = Event
   return o
end

--- Checks if the event script is finished or faulted
-- @treturn bool true if the event has finished
function Event:isFinished()
   error("Not implemented")
end

--- Checks if the event script is paused and waiting for a callback
-- @treturn bool true if the inner coroutine is in suspended state
function Event:isRunning()
   error("Not implemented")
end

--- Checks if the @{Event} script has been started
-- @treturn bool true if @{Event:start} has been called
function Event:isStarted()
   error("Not implemented")
end

--- Gets the @{Sandbox} of the inner @{coroutine}
-- @treturn fw.event.Sandbox The sandboxed environment of the inner @{coroutine}
function Event:getSandbox()
   error("Not implemented")
end

--- Starts the event script.
-- Will raise an error if the @{Event} has been started.
function Event:start()
   error("Not implemented")
end

return Event
