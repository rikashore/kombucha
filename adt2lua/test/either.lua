either = {}
local meta = { __index = either }
function either.left(_1)
    instance = {
        tag = "left",
        _1 = _1,
    }
    return setmetatable(instance, meta)
end
function either.right(_1)
    instance = {
        tag = "right",
        _1 = _1,
    }
    return setmetatable(instance, meta)
end
return either
