package.path = package.path .. ";./build/?.lua"

require("application")
require("layout")
require("label")

local app = Application:new("Layouts")
local layout = Layout:new(app, "HBox")

local label = Label:new(layout, "Text")
label:setTooltip("just label")
label:setSize(Vector2:new(100, 16))
label:turnDebug()

local label2 = Label:new(layout, "Next text")
label2:setTooltip("label 2")

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end