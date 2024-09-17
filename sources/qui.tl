require("slot")
require("window")
require("layout")

local qui = {
    new_window = Window.new,
    new_layout = Layout.new
}

function qui:process_events()
    for _, slot in pairs(slots) do
        slot:process()
    end
end

return qui