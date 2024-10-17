package.path = package.path .. ";./build/?.lua"
require("aura")

local app = Application:new("Groupbox")
local layout = Layout:new(app, "VBox")

local group = GroupBox:new(layout, Policy:new("Minimum"), "Some widgets", Vector2:new(400, 250))

Label:new(group, "Just text")
Label:new(group, "hello!")
Spacer:new(group, "Vertical")
Window:new(group, Policy:new("Minimum"), Vector2:new(150, 150))

while window.is_open() do
    app:update()

    window.clear()
    app:render()
    window.display()
end