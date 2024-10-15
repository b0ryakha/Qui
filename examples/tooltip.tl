package.path = package.path .. ";./build/?.lua"
require("qui")

local app = Application:new("Layouts")
local layout = Layout:new(app, "HBox")
layout:setSpacing(100)

local label = Label:new(layout, "Some text...")
label:setTooltip("Its just a label")

local win = Window:new(layout, "Fixed", Vector2:new(250, 250))
win:setTooltip("-> window $")

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end