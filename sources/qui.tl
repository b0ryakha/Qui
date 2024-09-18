require("slot")
require("window")
require("layout")
require("format")

local qui = {
    new_window = Window.new,
    new_layout = Layout.new,
    new_color = CachedColor.new,
    format = format
}

function qui:process_events()
    for _, slot in pairs(slots) do
        slot:process()
    end
end

return qui