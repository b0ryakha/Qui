require("format")

global type Data = { string : any }
global type Slot = function(Data)
global type Trigger = function(data: Data): boolean

global record Signal
    title: string
    trigger: Trigger
    slots: { Slot }
    data: Data

-- force decl:
    emit: function(Signal)
end

global signals: { string : Signal } = {};

function Signal:new(title: string, trigger: Trigger)
    local self: Signal = setmetatable({}, { __index = Signal })
    
    self.title = title
    self.trigger = trigger
    self.slots = {}
    self.data = {}
    
    signals[title] = self
end

-- private:
function Signal:runSlots()
    for _, slot in ipairs(self.slots) do
        slot(self.data)
    end
end

function Signal:process()
    if self.trigger and self.trigger(self.data) then
        self:runSlots()
    end
end

function Signal:emit()
    self:runSlots()
end

function Signal:addSlot(slot: Slot)
    table.insert(self.slots, slot)
end

local yellow = "\027[33m"
local white = "\027[37m"

global function connect(signal_title: string, slot: Slot)
    if signals[signal_title] then
        signals[signal_title]:addSlot(slot)
    else
        printf("[%warning%]: attempt to connect a callback to an unknown signal: \"%\"", yellow, white, signal_title)
    end
end

global function emit(signal_title: string)
    if signals[signal_title] then
        signals[signal_title]:runSlots()
    else
        printf("[%warning%]: attempt to emit an unknown signal: \"%\"", yellow, white, signal_title)
    end
end


Signal:new("window_size_changed", function(data: Data): boolean
    if not data.last_size then data.last_size = window.get_size() end

    if data.last_size ~= window.get_size() then
        data.last_size = window.get_size()
        return true
    end

    return false
end)

Signal:new("startup", function(data: Data): boolean
    if not data.started then
        data.started = true
        return true
    end

    return false
end)