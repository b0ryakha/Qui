global type Data = { string : any }
global type Trigger = function(data: Data): boolean
    
global type Signal = record
    title: string
    trigger: Trigger
end

function Signal:new(title: string, trigger: Trigger): Signal
    local self: Signal = setmetatable({}, { __index = Signal })
    
    self.title = title
    self.trigger = trigger
    
    return self
end

global signals: { string : Signal } = {};

signals.window_size_changed = Signal:new("WindowSizeChanged", function(data: Data): boolean
    if not data.last_size then data.last_size = window.get_size() end

    if data.last_size ~= window.get_size() then
        data.last_size = window.get_size()
        return true
    end

    return false
end)