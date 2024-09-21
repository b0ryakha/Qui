local record Base
    new: function<Self>(Self, ...: any)
end

global function extends<Child>(child: Child, base: Base, ...: any): Child
    local index = {}
    
    for k, v in pairs(base as table) do index[k] = v end
    for k, v in pairs(child as table) do index[k] = v end

    return setmetatable(base:new(...), { __index = index })
end