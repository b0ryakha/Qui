require("slot")

global type Trigger = function(data: Data): boolean

global record Signal
    trigger: Trigger
    slots: { Slot }
    data: Data
    force_emit: boolean

-- force decl:
    emit: function(Signal)
end

function Signal:new(trigger: Trigger): Signal
    local self: Signal = setmetatable({}, { __index = Signal })
    
    self.force_emit = false
    self.trigger = trigger
    self.slots = {}
    self.data = {}
    
    return self
end

-- private:
function Signal:runSlots()
    for _, slot in ipairs(self.slots) do
        slot:run(self.data)
    end
end

function Signal:process()
    if self.force_emit then
        self:runSlots()
        self.force_emit = false
    else
        if self.trigger and self.trigger(self.data) then
            self:runSlots()
        end
    end
end

function Signal:emit()
    self.force_emit = true
end

function Signal:addSlot(slot: Slot)
    table.insert(self.slots, slot)
end

global signals: { string : Signal } = {};

global function connect(signal: Signal, slot_callback: Callback)
    signal:addSlot(Slot:new(slot_callback))
end

signals.window_size_changed = Signal:new(function(data: Data): boolean
    if not data.last_size then data.last_size = window.get_size() end

    if data.last_size ~= window.get_size() then
        data.last_size = window.get_size()
        return true
    end

    return false
end)

signals.startup = Signal:new(function(data: Data): boolean
    if not data.started then
        data.started = true
        return true
    end

    return false
end)