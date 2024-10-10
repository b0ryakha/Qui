local record Class
    __type: string
    new: function<Self>(Self, ...: any)
end

global function typeof(object: any): string
    return (object as Class).__type
end

global function create<T>(class: T, name: string): T
    (class as Class).__type = name
    return setmetatable({}, { __index = class }) as T
end

global function extends<Child>(child: Child, name: string, base: any, ...: any): Child
    local index = {}
    
    for k, v in pairs(base as table) do index[k] = v end
    for k, v in pairs(child as table) do index[k] = v end

    index.__type = name

    return setmetatable((base as Class):new(...), { __index = index })
end