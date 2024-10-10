package.path = package.path .. ";./build/?.lua"

require("signal")
require("window")
require("layout")

local win = Window:new(nil, "Maximum")
local layout = Layout:new(win, "HBox")

layout:addItem(Window:new(nil, "Fixed", Vector2:new(100, 100)))
layout:addItem(Window:new(nil, "Minimum", Vector2:new(250, 250)))

for i = 1, layout:itemsCount() do
    (layout:at(i) as Window):setBackgroundColor(CachedColor:new(cmath.rand_int(0, 255), cmath.rand_int(0, 255), cmath.rand_int(0, 255)))
end

local vlayout = Layout:new(layout, "VBox")
vlayout:setMargin(Margin:new(0, 0, 0, 0))

vlayout:addItem(Window:new(nil, "Maximum"))
vlayout:addItem(Window:new(nil, "Minimum", Vector2:new(250, 250)))

for i = 1, vlayout:itemsCount() do
    (vlayout:at(i) as Window):setBackgroundColor(CachedColor:new(cmath.rand_int(0, 255), cmath.rand_int(0, 255), cmath.rand_int(0, 255)))
end

while window.is_open() do
    process_signals()

    window.clear()
    win:render()
    window.display()
end