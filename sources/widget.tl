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

    size: Vector2
    size_policy: SizePolicy

    is_visible: boolean
    is_aligned: boolean

-- force decl:
    tostring: function(Widget): string
    show: function(Widget)
    align: function(Widget)
    warp: function(Widget)
    getSize: function(Widget): Vector2
    updateSelf: function(Widget)
end

function Widget:new(parent: WidgetHeir, size: Vector2, size_policy: SizePolicy): Widget
    local self: Widget = setmetatable({}, { __index = Widget })

    self.parent = parent as Widget
    self.childs = {}

    self.pos = Vector2:new(0, 0)
    self.margin = Margin:new(8, 8, 8, 8)

    self.size = size and size:copy() or nil
    self.size_policy = size_policy or "Minimum"

    self.is_visible = true
    self.is_aligned = false

    connect(signals.window_size_changed, function()
        self.is_aligned = false
        self:updateSelf()
    end)

    if self.parent then
        table.insert(self.parent.childs, self)
    end

    self:align()
    self:updateSelf()
    
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
    if self.size_policy == "Fixed" then return end

    if self.size_policy == "Maximum" then
        --dbg()
        if self.parent then
            self.size = self.parent:getSize()
        else
            self.size = window.get_size()
        end
    else
        if self.size_policy == "Minimum" then
            if next(self.childs) ~= nil then
                local max_size = Vector2:new(0, 0)

                for _, child in ipairs(self.childs) do
                    local child_size = child:getSize()
                    if max_size.x < child_size.x then max_size.x = child_size.x end
                    if max_size.y < child_size.y then max_size.y = child_size.y end
                end

                self.size = max_size
            elseif not self.size then
                self.size = Vector2:new(100, 100)
            end
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
    self:update()

    if not self.is_aligned then
        self:warp()
        self:clamp()
        self.is_aligned = true
    end
end

function Widget:addItem(item: WidgetHeir)
    local w: Widget = item as Widget

    w.parent = self
    table.insert(self.childs, w)

    w:align()
    w:updateSelf()

    self:align()
    self:updateSelf()
end

function Widget:getSize(): Vector2
    return self.size:copy()
end

function Widget:setSize(size: Vector2)
    self.size = size:copy()
    self:updateSelf()
end

function Widget:setSizePolicy(policy: SizePolicy)
    self.size_policy = policy
    self:updateSelf()
end

function Widget:getSizePolicy(): SizePolicy
    return self.size_policy
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
    self:align()
    self:updateSelf()
end

function Widget:hide()
    self.is_visible = false
end