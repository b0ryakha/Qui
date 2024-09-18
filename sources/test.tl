package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:new_window("Maximum")
local child_win = qui:new_window(win, Vector2:new(1000, 500), "Fixed")

local layout = qui:new_layout(child_win, "HBox", nil, "Maximum")
layout:turnDebugLines()

layout:addItem(qui:new_window(nil, Vector2:new(250, 250), "Fixed"))

for i = 1, 4 do
    layout:addItem(qui:new_window(nil, Vector2:new(250, 250)))
end

layout:addItem(qui:new_window(nil, Vector2:new(500, 250), "Maximum"))

while window.is_open() do
    qui:process_events()
    win:show()
end