option = {}
local meta = { __index = option }
function option.some(_1)
    instance = {
        tag = "some",
        _1 = _1,
    }
    return setmetatable(instance, meta)
end
function option.none()
    instance = {
        tag = "none",
    }
    return setmetatable(instance, meta)
end
return option
