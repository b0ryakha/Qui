package.path = package.path .. ";./build/?.lua"
require("qui")

local app = Application:new("Explorer")
local main = Layout:new(app, "VBox")
main:setSpacing(0)
main:setMargin(Margin:new(0, 0, 0, 0))

local header = Layout:new(main, "HBox", "Minimum", Vector2:new(main.size.x, 44))
header:turnDebug()

local al = Icon:new(header, "./examples/assets/arrow_left.png", "Fixed", Vector2:new(21, 21))
al:setTooltip("prev folder")

local ar = Icon:new(header, "./examples/assets/arrow_right.png", "Fixed", Vector2:new(21, 21))
ar:setTooltip("next folder")

local ad = Icon:new(header, "./examples/assets/arrow_down.png", "Fixed", Vector2:new(12, 12))
ad:setTooltip("menu...")

local au = Icon:new(header, "./examples/assets/arrow_up.png", "Fixed", Vector2:new(21, 21))
au:setTooltip("back to folder")

local search = Window:new(header, "Maximum")
search:setTooltip("search...")

local page = Layout:new(main, "HBox")
page:turnDebug()
page:setSpacing(4)

local list = Window:new(page, "Minimum", Vector2:new(200, page.size.y))
list:setTooltip("list of folders =)")

local view = Window:new(page, "Maximum")
view:setTooltip("folder view =)")

while window.is_open() do
    window.clear()
    app:render()
    window.display()
end