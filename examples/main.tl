package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:window("Maximum")

local layout = qui:layout(win, "HBox")
layout:turnDebug()

local l_child = qui:window(layout, qui:vec2(250, 250), "Maximum")
local lc_layout = qui:layout(l_child, "HBox", "Maximum")
qui:window(lc_layout, qui:vec2(100, 100)):setBackgroundColor(qui:color(50, 50, 50))
qui:window(lc_layout, qui:vec2(100, 100), "Maximum"):setBackgroundColor(qui:color(200, 200, 200))

layout:addItem(qui:window(qui:vec2(120, 300)))
qui:spacer(layout, "Horizontal"):turnDebug()

local label = qui:label(layout, "Text!")

layout:addItem(qui:window(qui:vec2(250, 250), "Minimum"))
layout:addItem(qui:window(qui:vec2(500, 250), "Maximum"))

while window.is_open() do
    qui:process_events()

    window.clear(qui:color(20, 20, 20))
    win:render()
    window.display()
end