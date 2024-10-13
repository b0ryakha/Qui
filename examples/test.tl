package.path = package.path .. ";./build/?.lua"

require("signal")
require("window")
require("layout")

local win = Window:new(nil, "Maximum")

local layout = Layout:new(win, "HBox")
layout:turnDebug()

layout:addItem(Window:new(nil, "Minimum", Vector2:new(150, 150)))

while window.is_open() do
    process_signals()

    window.clear()
    win:render()
    window.display()
end