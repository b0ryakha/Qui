package.path = package.path .. ";./build/?.lua"

require("application")
require("window")
require("layout")
require("icon")

local app = Application:new("Explorer")
local main = Layout:new(app, "VBox")
main:setSpacing(0)
main:setMargin(Margin:new(0, 0, 0, 0))

local header = Layout:new(main, "HBox", "Minimum", Vector2:new(main.size.x, 44))
header:turnDebug()
Icon:new(header, "./examples/assets/arrow_left.png", "Fixed", Vector2:new(21, 21))
Icon:new(header, "./examples/assets/arrow_right.png", "Fixed", Vector2:new(21, 21))
Icon:new(header, "./examples/assets/arrow_down.png", "Fixed", Vector2:new(12, 12))
Icon:new(header, "./examples/assets/arrow_up.png", "Fixed", Vector2:new(21, 21))
Window:new(header, "Maximum")

local page = Layout:new(main, "HBox")
page:turnDebug()
page:setSpacing(4)
Window:new(page, "Minimum", Vector2:new(200, page.size.y))
Window:new(page, "Maximum")

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end