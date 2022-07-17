<img src = "https://user-images.githubusercontent.com/94554616/179428020-b0ba6c1f-19b1-40de-b65f-29b497a07303.png" width = 450>

StateX is a powerful, yet easy state management solution. It makes use of the reactive state management and general state management to let your project manages states efficiently.

# Reactive State Management

One of the truly unique features about this **stand-alone** state management library is that you can efficiently manage states reactively. To acheive this, StateX offers a reactiveState class which it's constructor accepts a function to call whenever you use it, or in other words, it performs a computation whenever needed rather than updating data once a signal is fired.

Here is an example to show reactive state management

```lua
local StateX = require(PATH_TO_STATE_X)
local State = StateX.state
local ReactiveState = StateX.reactiveState


local Health = state(100)
local midHealth = ReactiveState(function() 
   return Health:get() / 2
end)

print(midHealth:get()) -- 50
Health:set(50)
print(midHealth:get()) -- 25

```

# General State Management
Although reactive state management is truly efficient in many cases, StateX offers an API to listen to non reactive states updates.


Here is an example to show simulate reactive state management

```lua
local StateX = require(PATH_TO_STATE_X)
local State = StateX.state


local Health = state(100)
local midHealth = Health:get() / 2

Health:ListenToChanges(function(_, NewValue) 
  midHealth = NewValue / 2
end)

```

