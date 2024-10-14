package.path = package.path .. ";./build/?.lua"

require("application")
require("layout")
require("label")

local app = Application:new("Layouts")
local layout = Layout:new(app, "VBox")

local label = Label:new(layout, "Aligned text")
label:setSize(Vector2:new(100, 200))
label:turnDebug()
label:setAlignment("Center", "Down")

Label:new(layout, "Just text")

local link = Label:new(layout, "https://www.youtube.com/")
link:makeClickable()

while window.is_open() do
    app:update()

    window.clear()
    app:render()
    window.display()
end