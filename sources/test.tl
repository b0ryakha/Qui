package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:window("Maximum")
local wchild = qui:window(win, qui:vec2(1000, 500), "Fixed")
wchild:setMargin(qui:margins(0, 0, 0, 0))

local layout = qui:layout(wchild, "HBox", "Maximum")
layout:turnDebugLines()

local lchild = qui:window(layout, qui:vec2(250, 250), "Maximum")
local lclayout = qui:layout(lchild, "HBox", "Maximum")
lclayout:turnDebugLines()
qui:window(lclayout, qui:vec2(100, 100)):setBackgroundColor(qui:color(255, 150, 0))

layout:addItem(qui:window(qui:vec2(120, 300), "Fixed"))
layout:addItem(qui:window(qui:vec2(250, 250)))
layout:addItem(qui:window(qui:vec2(250, 250)))
layout:addItem(qui:window(qui:vec2(500, 250), "Maximum"))

layout:align()

while window.is_open() do
    qui:process_events()
    win:show()
end