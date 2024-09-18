require("signal")
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
    for _, signal in pairs(signals) do
        signal:process()
    end
end

return qui