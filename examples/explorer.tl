package.path = package.path .. ";./build/?.lua"

require("signal")
require("window")
require("layout")
require("icon")

local win = Window:new(nil, "Maximum")
local main = Layout:new(win, "VBox")
main:setStretch(main.margin.top)

local header = Layout:new(main, "HBox", "Minimum", Vector2:new(main.size.x, 44))
header:turnDebug()
Icon:new(header, "./examples/assets/arrow_left.png", "Fixed", Vector2:new(21, 21))
Icon:new(header, "./examples/assets/arrow_right.png", "Fixed", Vector2:new(21, 21))
Icon:new(header, "./examples/assets/arrow_down.png", "Fixed", Vector2:new(12, 12))
Icon:new(header, "./examples/assets/arrow_up.png", "Fixed", Vector2:new(21, 21))
Window:new(header, "Maximum")

local page = Layout:new(main, "HBox")
page:turnDebug()
page:setStretch(4)
Window:new(page, "Minimum", Vector2:new(200, page.size.y))
Window:new(page, "Maximum")

while window.is_open() do
    process_signals()

    window.clear()
    win:render()
    window.display()
end