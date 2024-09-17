local type BaseClass = record
    new: function(BaseClass, ...: any)
end

global function extends<ChildClass>(child: ChildClass, base: BaseClass, args: { integer : any }): ChildClass
    local index = {}
    
    for k, v in pairs(base as { string : any }) do index[k] = v end
    for k, v in pairs(child as { string : any }) do index[k] = v end

    return setmetatable(base:new(table.unpack(args)), { __index = index })
end