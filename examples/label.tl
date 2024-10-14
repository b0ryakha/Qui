package.path = package.path .. ";./build/?.lua"

require("application")
require("layout")
require("label")

local app = Application:new("Layouts")
local layout = Layout:new(app, "HBox")

local label = Label:new(layout, "Text")
label:setSize(Vector2:new(100, 16))
label:setTooltip("just label")
label:turnDebug()

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end