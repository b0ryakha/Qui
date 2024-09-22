require("widget")
require("cachedcolor")
require("oop")
require("margin")
require("spacer")
require("log")

global enum LayoutType
    "HBox" "VBox" "Grid"
end

global record Layout
    type: LayoutType
    margin: Margin
    stretch: number

    is_debug: boolean
    debug_color: Color

-- Widget decl:
    parent: Widget
    childs: { Widget }
    pos: Vector2
    size: Vector2
    size_policy: SizePolicy
    hide: function<Self>(Self)
    addChild: function<Self>(Self, WidgetHeir)
    setSize: function<Self>(Self, Vector2)
    setPos: function<Self>(Self, Vector2)
    isVisible: function<Self>(Self): boolean
end

-- Layout(parent: WidgetHeir, align_type: LayoutType, size: Vector2, size_policy: SizePolicy)
-- Layout(parent: WidgetHeir, align_type: LayoutType, size_policy: SizePolicy)
-- Layout(parent: WidgetHeir, align_type: LayoutType)
function Layout:new(parent: WidgetHeir, align_type: LayoutType, size: Vector2 | SizePolicy, size_policy: SizePolicy): Layout
    if type(size) == "string" then
        size_policy = size as SizePolicy
        size = nil
    end

    local self = extends(Layout, Widget, parent, size, size_policy)
    if self.parent then
        self.parent:setLayout(self)
    end

    self.type = align_type
    self.margin = Margin:new(8, 8, 8, 8)
    self.stretch = 16

    self.is_debug = false
    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:addItem(item_heir: WidgetHeir)
    if not item_heir then
        warning("Layout: Cannot add a nil item")
        return
    end

    self:addChild(item_heir as Widget)
end

-- private:
function Layout:warp(child: Widget)
    if child.size_policy == "Fixed" then return end

    local right_edge = self.pos.x + self.size.x - self.margin.right
    if (child.pos.x + child.size.x) >= right_edge then
        child.size.x = child.size.x - (child.pos.x + child.size.x - right_edge)
    end
            
    local bottom_edge = self.pos.y + self.size.y - self.margin.bottom
    if (child.pos.y + child.size.y) >= bottom_edge then
        child.size.y = child.size.y - (child.pos.y + child.size.y - bottom_edge)
    end
end

-- private:
function Layout:horizontalAlign()
    local total_width = self.size.x - self.margin.left - self.margin.right
    local flexible_width = total_width
    local warp_count = 0

    for _, child in ipairs(self.childs) do
        if child.size_policy == "Maximum" then
            warp_count = warp_count + 1
        else
            flexible_width = flexible_width - child.size.x
        end
    end

    if warp_count > 0 then
        local width_per_child = flexible_width / warp_count

        for _, child in ipairs(self.childs) do
            if child.size_policy == "Maximum" then
                if (child as Spacer).align_type ~= "Vertical" then
                    child.size.x = width_per_child
                end
                
                if (child as Spacer).align_type ~= "Horizontal" then
                    child.size.y = self.size.y - self.margin.top - self.margin.bottom
                end
            end
        end
    end

    local current_x = self.pos.x + self.margin.left

    for _, child in ipairs(self.childs) do
        child.pos.x = current_x
        child.pos.y = self.pos.y + self.margin.top
        self:warp(child)

        current_x = current_x + child.size.x + self.stretch
    end
end

-- override:
function Layout:update()
    if self.type == "HBox" then self:horizontalAlign() end
    if self.type == "VBox" then error("not impl") end
    if self.type == "Grid" then error("not impl") end

    for _, child in ipairs(self.childs) do
        child:update()
    end
end

-- override
function Layout:render()
    if not self:isVisible() then return end

    if self.is_debug then
        render.rectangle(
            self.pos.x as integer,
            self.pos.y as integer,
            self.size.x as integer,
            self.size.y as integer,
            self.debug_color
        )
    end

    for _, child in ipairs(self.childs) do
        child:render()
    end
end

function Layout:setStretch(stretch: number)
    self.stretch = stretch
end

function Layout:turnDebug(is_debug: boolean)
    self.is_debug = is_debug == nil and true or is_debug
end

function Layout:getMargin(): Margin
    return self.margin:copy()
end

function Layout:setMargin(margin: Margin)
    self.margin = margin:copy()
end