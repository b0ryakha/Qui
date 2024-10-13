package.path = package.path .. ";./build/?.lua"

require("application")
require("window")
require("layout")
require("spacer")

local app = Application:new("Layouts")

local layout = Layout:new(app, "HBox")
layout:turnDebug()

layout:addItem(Window:new(nil, "Fixed", Vector2:new(100, 100)))
layout:addItem(Window:new(nil, "Minimum", Vector2:new(250, 250)))

local vlayout = Layout:new(layout, "VBox")
vlayout:turnDebug()

vlayout:addItem(Window:new(nil, "Maximum"))
local spacer = Spacer:new(nil, "Vertical")
spacer:turnDebug()
vlayout:addItem(spacer)
vlayout:addItem(Window:new(nil, "Minimum", Vector2:new(100, 100)))

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end