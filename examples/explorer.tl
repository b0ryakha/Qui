package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:window("Maximum")
local main = qui:layout(win, "VBox")
main:setStretch(main.margin.top)

local header = qui:layout(main, "HBox", qui:vec2(main.size.x, 44), "Minimum")
header:turnDebug()
qui:icon(header, "./examples/assets/arrow_left.png", qui:vec2(21, 21))
qui:icon(header, "./examples/assets/arrow_right.png", qui:vec2(21, 21))
qui:icon(header, "./examples/assets/arrow_down.png", qui:vec2(12, 12))
qui:icon(header, "./examples/assets/arrow_up.png", qui:vec2(21, 21))
qui:window(header, nil, "Maximum")

local page = qui:layout(main, "HBox")
page:turnDebug()
page:setStretch(4)
qui:window(page, qui:vec2(200, page.size.y), "Minimum")
qui:window(page, nil, "Maximum")

while window.is_open() do
    qui:process_events()

    window.clear()
    win:render()
    window.display()
end