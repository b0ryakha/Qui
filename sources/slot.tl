global type Data = { string : any }
global type Callback = function(Data)

global record Slot
    callback: Callback
end

function Slot:new(callback: Callback): Slot
    local self: Slot = setmetatable({}, { __index = Slot })

    self.callback = callback

    return self
end

function Slot:run(data: Data)
    self.callback(data)
end