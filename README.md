<img src = "https://user-images.githubusercontent.com/94554616/179428020-b0ba6c1f-19b1-40de-b65f-29b497a07303.png" width = 450>

StateX is a powerful, yet easy state management solution. It makes use of the reactive state management and static state management to let your project manages states efficiently.

# Why use it over other alternatives?
StateX is a simple, yet a powerful state management library that makes use of reactive state management and static state management to achieve maximum efficiency and customizability, making it easier and simpler to use while acheiving acceptable speed results. In other words, StateX is a lot easier to start with and to maintain while providing truly reactive states as well.

# What features this library offers?
StateX offers the following:
1. Simple API to maintain while also powerful 
2. Consistent API within Reactive/States
3. Type protection which allows you to track down bugs before shipping them to production
4. Reactive States to allow you build up bonds between states reactively
5. reactive/States are shareable between scripts.
7. Allowing you to listen to changes in a non reactive state 
8. Allow listening to certain keys in a table


# Whats stopping me from just changing a variable and calling a function when...?
it unlocks the potential for your projects to become much more powerful and declarative. It gives a clear structure to your projects (better organization), and can make things much easier to work with. Additionally, using modules, you can share the state between scripts.

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


Here is an example to show how to simulate reactive state management

```lua
local StateX = require(PATH_TO_STATE_X)
local State = StateX.state


local Health = state(100)
local midHealth = Health:get() / 2

Health:ListenToChanges(function(_, NewValue) 
  midHealth = NewValue / 2
end)

```

