package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:new_window("Maximum")
local child_win = qui:new_window(win, Vector2:new(1000, 500), "Fixed")

local layout = qui:new_layout(child_win, "HBox", nil, "Maximum")
layout:turnDebugLines()

layout:addItem(qui:new_window(nil, Vector2:new(250, 250), "Fixed"))
layout:addItem(qui:new_window(nil, Vector2:new(250, 250)))
layout:addItem(qui:new_window(nil, Vector2:new(500, 250), "Maximum"))
layout:addItem(qui:new_window(nil, Vector2:new(250, 250)))

while window.is_open() do
    qui:process_events()
    win:show()
end