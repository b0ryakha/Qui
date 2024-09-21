package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:window(qui:vec2(1000, 500))
win:setPosition(qui:vec2(16, 16))

local layout = qui:layout(win, "HBox")
layout:turnDebugLines()

-- stack overflow:
local l_child = qui:window(layout, qui:vec2(250, 250), "Maximum")
--local lc_layout = qui:layout(l_child, "HBox", "Maximum")
--lc_layout:turnDebugLines()
--qui:window(lc_layout, qui:vec2(100, 100), "Minimum"):setBackgroundColor(qui:color(255, 150, 0))

layout:addItem(qui:window(qui:vec2(120, 300)))
layout:addItem(qui:window(qui:vec2(250, 250), "Minimum"))
layout:addItem(qui:window(qui:vec2(250, 250), "Minimum"))
layout:addItem(qui:window(qui:vec2(500, 250), "Maximum"))
layout:addItem(qui:window(qui:vec2(500, 250), "Maximum"))

while window.is_open() do
    qui:process_events()

    window.clear(qui:color(20, 20, 20))
    win:render()
    window.display()
end