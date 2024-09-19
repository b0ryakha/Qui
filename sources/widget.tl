require("sizepolicy")
require("margin")
require("signal")

require("format")
global dbg = require("externals/debugger/debugger") as Debugger

global type WidgetHeir = any

global record Widget
    parent: Widget
    childs: { Widget }

    pos: Vector2
    margin: Margin

    is_outside_size: boolean
    size: Vector2
    size_policy: SizePolicy

    is_visible: boolean

-- force decl:
    setSize: function(Widget, Vector2)
    getSize: function(Widget): Vector2
    tostring: function(Widget): string
    show: function(Widget)
    align: function(Widget)
    warp: function(Widget)
    updateSelf: function(Widget)
end

function Widget:new(parent: WidgetHeir, size: Vector2, size_policy: SizePolicy): Widget
    local self: Widget = setmetatable({}, { __index = Widget })

    self.parent = parent as Widget
    self.childs = {}

    self.pos = Vector2:new(0, 0)
    self.margin = Margin:new(8, 8, 8, 8)

    self.is_outside_size = false
    self.size_policy = size_policy or "Minimum"

    self.is_visible = true

    connect("window_size_changed", function() self:updateSelf() end)
    connect("startup", function() self:updateSelf() end)

    if self.parent then
        table.insert(self.parent.childs, self)
    end
    
    self:setSize(size or Vector2:new(100, 100))
    self:align()
    
    return self
end

-- virtual:
function Widget:tostring(): string
    return format("Widget(pos: %, margin: %, size: %, policy: \"%\")", self.pos, self.margin, self.size, self.size_policy)
end

-- pure virtual:
function Widget:show() end
function Widget:update() end

-- private:
function Widget:align()
    if not self.parent then return end

    self.pos.x = self.parent.pos.x + self.parent.margin.left
    self.pos.y = self.parent.pos.y + self.parent.margin.top
end

-- private:
function Widget:warp()
    if self.is_outside_size then return end

    if self.size_policy == "Maximum" then
        if self.parent then
            self.size = self.parent:getSize()
        else
            self.size = window.get_size()
        end
    end
end

-- private:
function Widget:clamp()
    if not self.parent then return end
    if self.size_policy == "Fixed" then return end

    local right_edge = self.parent.pos.x + self.parent.size.x - self.parent.margin.right
    if (self.pos.x + self.size.x) >= right_edge then
        self.size.x = self.size.x - (self.pos.x + self.size.x - right_edge)
    end
    
    local bottom_edge = self.parent.pos.y + self.parent.size.y - self.parent.margin.bottom
    if (self.pos.y + self.size.y) >= bottom_edge then
        self.size.y = self.size.y - (self.pos.y + self.size.y - bottom_edge)
    end
end

function Widget:updateSelf()
    self:warp()
    self:clamp()

    for _, child in ipairs(self.childs) do
        child:updateSelf()
    end

    self:update()
end

function Widget:getSize(): Vector2
    return self.size:copy()
end

function Widget:setSize(size: Vector2)
    self.size = size:copy()
    self:updateSelf()
end

function Widget:getGlobalPos(): Vector2
    return self.pos:copy()
end

function Widget:setGlobalPos(pos: Vector2)
    self.pos = pos:copy()
    self:updateSelf()
end

function Widget:getPos(): Vector2
    if not self.parent then
        return self:getGlobalPos()
    end

    return self.pos - self.parent.pos
end

function Widget:getMargin(): Margin
    return self.margin:copy()
end

function Widget:setMargin(margin: Margin)
    self.margin = margin:copy()
end

function Widget:hide()
    self.is_visible = false
end