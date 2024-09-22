require("cachedcolor")
require("widget")
require("oop")

global record Window
    bg_color: Color
    ol_color: Color
    rounding: integer

-- Widget decl:
    parent: Widget
    childs: { Widget }
    pos: Vector2
    size: Vector2
    size_policy: SizePolicy
    isVisible: function<Self>(Self): boolean
    getPosition: function<Self>(Self): Vector2
    setPosition: function<Self>(Self, Vector2)
    setLayout: function<Self>(Self, WidgetHeir)
end

-- Window(parent: WidgetHeir, size: Vector2, size_policy: SizePolicy)
-- Window(size: Vector2, size_policy: SizePolicy)
-- Window(size: Vector2)
-- Window(size_policy: SizePolicy)
function Window:new(parent: WidgetHeir | Vector2, size: Vector2 | SizePolicy, size_policy: SizePolicy): Window
    if type(parent) == "string" and not size and not size_policy then
        size_policy = parent as SizePolicy
        parent = nil
        size = nil
    elseif (parent as Vector2).x ~= nil and (parent as Vector2).y ~= nil then
        size_policy = size as SizePolicy
        size = parent as Vector2
        parent = nil
    end

    local self = extends(Window, Widget, parent, size, size_policy)

    if not parent and not size and size_policy == "Maximum" then
        self.size = window.get_size()
        connect("window_resized", function()
            local new_size = window.get_size()
            self.size.x = new_size.x
            self.size.y = new_size.y
        end)
    end

    self.bg_color = CachedColor:new(35, 35, 35)
    self.ol_color = CachedColor:new(70, 70, 70)
    self.rounding = 2

    return self
end

-- override
function Window:render()
    if not self:isVisible() then return end

    local x <const>: integer = self.pos.x as integer
    local y <const>: integer = self.pos.y as integer
    local w <const>: integer = self.size.x as integer
    local h <const>: integer = self.size.y as integer

    if self.parent then
        local thickness <const> = 1
        render.rectangle(x, y, w, h, self.ol_color, self.rounding)
        render.rectangle(x + thickness, y + thickness, w - thickness * 2, h - thickness * 2, self.bg_color, self.rounding)
    else
        render.rectangle(x, y, w, h, self.bg_color)
    end

    for _, child in ipairs(self.childs) do
        child:render()
    end
end

function Window:getBackgroundColor(): Color
    return self.bg_color:copy()
end

function Window:setBackgroundColor(color: Color)
    self.bg_color = color
end

function Window:getOutlineColor(): Color
    return self.ol_color:copy()
end

function Window:setOutlineColor(color: Color)
    self.ol_color = color
end