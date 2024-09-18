require("signal")

global type Callback = function(Data)

global record Slot
    title: string
    callbacks: { Callback }
    signal: Signal
    data: Data
end

function Slot:new(title: string, signal: Signal, callbacks: { Callback }): Slot
    local self: Slot = setmetatable({}, { __index = Slot })

    self.title = title
    self.callbacks = callbacks
    self.signal = signal
    self.data = {}

    return self
end

function Slot:process()
    if not self.signal or self.signal.trigger(self.data) then
        if not self.callbacks then return end
        for _, callback in ipairs(self.callbacks) do
            callback(self.data)
        end
    end
end

function Slot:addCallback(callback: Callback)
    table.insert(self.callbacks, callback)
end

global slots: { string : Slot } = {};

global function connect(signal: Signal, slot_title: string, callback: Callback)
    if not slots[slot_title] then
        slots[slot_title] = Slot:new(slot_title, signal, { callback })
    else
        slots[slot_title]:addCallback(callback)
    end
end