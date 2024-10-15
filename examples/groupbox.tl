package.path = package.path .. ";./build/?.lua"
require("qui")

local app = Application:new("Groupbox")
local layout = Layout:new(app, "VBox")

local group = GroupBox:new(layout, "Fixed", "Simple group", Vector2:new(500, 300))

Label:new(group, "Just text")
Label:new(group, "hello!")
Spacer:new(group, "Vertical")
Window:new(group, "Fixed", Vector2:new(150, 150))

while window.is_open() do
    app:update()

    window.clear()
    app:render()
    window.display()
end