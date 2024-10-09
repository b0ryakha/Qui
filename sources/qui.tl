require("window")
require("layout")
require("label")
require("spacer")
require("icon")

local qui = {
    window = Window.new,
    layout = Layout.new,
    label = Label.new,
    font = CachedFont.new,
    spacer = Spacer.new,
    icon = Icon.new,

    vec2 = Vector2.new,
    marg = Margin.new,

    color = CachedColor.new,
    color_rand = function(_: any): Color
        return CachedColor:new(cmath.rand_int(0, 255), cmath.rand_int(0, 255), cmath.rand_int(0, 255))
    end,
}

function qui:process_events()
    for _, signal in pairs(signals) do
        signal:process()
    end
end

return qui