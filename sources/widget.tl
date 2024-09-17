require("sizepolicy")
require("margin")
require("slot")

global type WidgetHeir = any

global type Widget = record
    parent: Widget
    childs: { Widget }

    pos: Vector2
    margin: Margin

    size: Vector2
    size_policy: SizePolicy

-- force decl:
    show: function(Widget)
    update: function(Widget)
    align: function(Widget)
    clamp: function(Widget)
    stretch: function(Widget)
    getSize: function(Widget): Vector2
end

function Widget:new(parent: WidgetHeir, size: Vector2, size_policy: SizePolicy): Widget
    local self: Widget = setmetatable({}, { __index = Widget })

    self.parent = parent as Widget
    self.childs = {}

    self.pos = Vector2:new(0, 0)
    self.margin = Margin:new(8, 8, 8, 8)

    self.size = size and size:copy() or window.get_size()
    self.size_policy = size_policy or "Minimum"

    connect(signals.window_size_changed, "updateWidgetsSize", function(data: Data)
        if not data.last_size then return end
        error(tostring(data.last_size))
    end)

    if self.parent then
        self:update()
        self:align()
        self:stretch()
        self:clamp()
    
        table.insert(self.parent.childs, self)
    end
    
    return self
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
function Widget:stretch()
    if self.size_policy == "Fixed" then return end

    if self.size_policy == "Maximum" then
        if self.parent then
            self.size = self.parent:getSize()
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
            else
                self.size = Vector2:new(100, 100)
            end
        end
    end
end

-- private:
function Widget:clamp()
    if not self.parent then return end

    if (self.pos.x + self.size.x) >= (self.parent.pos.x + self.parent.size.x - self.parent.margin.right) then
        self.size.x = self.parent.size.x - self.parent.margin.right * 2
    end
    
    if (self.pos.y + self.size.y) >= (self.parent.pos.x + self.parent.size.y - self.parent.margin.bottom) then
        self.size.y = self.parent.size.y - self.parent.margin.bottom * 2
    end
end

function Widget:addItem(item: WidgetHeir)
    local w: Widget = item as Widget

    w.parent = self
    table.insert(self.childs, w)

    self:update()
    w:align()
    w:stretch()
    w:clamp()
end

function Widget:getSize(): Vector2
    return self.size:copy()
end

function Widget:setSizePolicy(policy: SizePolicy)
    self.size_policy = policy
end

function Widget:getSizePolicy(): SizePolicy
    return self.size_policy
end

function Widget:getGlobalPos(): Vector2
    return self.pos:copy()
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