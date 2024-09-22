package.path = package.path .. ";./build/?.lua"

local qui = require("qui")

local win = qui:window("Maximum")
local layout = qui:layout(win, "HBox")

layout:addItem(qui:window(qui:vec2(100, 100)))
layout:addItem(qui:window(qui:vec2(250, 250), "Minimum"))

for i = 1, layout:itemsSize() do
    (layout:at(i) as Window):setBackgroundColor(qui:color_rand())
end

local vlayout = qui:layout(layout, "VBox")
vlayout:setMargin(qui:marg(0, 0, 0, 0))

vlayout:addItem(qui:window("Maximum"))
vlayout:addItem(qui:window(qui:vec2(250, 250), "Minimum"))

for i = 1, vlayout:itemsSize() do
    (vlayout:at(i) as Window):setBackgroundColor(qui:color_rand())
end

while window.is_open() do
    qui:process_events()

    window.clear()
    win:render()
    window.display()
end