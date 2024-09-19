require("signal")
require("window")
require("layout")
require("format")

local qui = {
    margins = Margin.new,
    window = Window.new,
    layout = Layout.new,
    color = CachedColor.new,
    vec2 = Vector2.new,
    format = format
}

function qui:process_events()
    for _, signal in pairs(signals) do
        signal:process()
    end
end

return qui