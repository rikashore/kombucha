local enum = {}

function enum.enum(names)
    t = {}
    for i, name in pairs(names) do
        t[name] = i
    end
    return setmetatable(t, {
        __index = t,
        __newindex = function(t, key, value)
                       error("Attempt to modify enum value")
                     end,
        __metatable = false
      })
end

return enum
