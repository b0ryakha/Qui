require("window")
require("layout")
require("label")

local qui = {
    window = Window.new,
    layout = Layout.new,
    color = CachedColor.new,
    vec2 = Vector2.new,
    marg = Margin.new,
    label = Label.new,
    font = CachedFont.new
}

function qui:process_events()
    for _, signal in pairs(signals) do
        signal:process()
    end
end

return qui