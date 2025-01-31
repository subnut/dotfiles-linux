--[[

  Returns a callback that calls the given function with the remaining
  arguments as the arguments of that function

--]]

return function(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end
