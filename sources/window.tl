require("cachedcolor")
require("widget")
require("oop")

global record Window
    bg_color: Color
    ol_color: Color
    rounding: integer

-- Widget decl:
    is_visible: boolean
    parent: Widget
    childs: { Widget }
    pos: Vector2
    margin: Margin
    size: Vector2
    size_policy: SizePolicy
    addItem: function(Window, WidgetHeir)
    setSizePolicy: function(Window, SizePolicy)
    align: function(Window)
    setMargin: function(Window, Margin)
    setGlobalPos: function(Window, Vector2)
    setSize: function(Window, Vector2)
    hide: function(Window)
end

function Window:new(parent: WidgetHeir | SizePolicy, size: Vector2, size_policy: SizePolicy): Window
    if type(parent) == "string" then
        size_policy = parent as SizePolicy
        parent = nil
        size = nil
    end

    local self = extends(Window, Widget, { parent, size, size_policy })

    self.bg_color = CachedColor:new(36, 36, 36)
    self.ol_color = CachedColor:new(69, 69, 69)
    self.rounding = 2

    return self
end

-- private:
function Window:render()
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
        child:show()
    end
end

function Window:show()
    if not self.is_visible then return end

    if self.parent then
        self:render()
    else
        window.clear()
        self:render()
        window.display()
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

function Window:getRounding(): integer
    return self.rounding
end

function Window:setRounding(rounding: integer)
    self.rounding = rounding
end