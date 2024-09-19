require("widget")
require("cachedcolor")
require("oop")

global enum LayoutType
    "HBox" "VBox" "Grid"
end

global record Layout
    is_debug: boolean
    type: LayoutType
    debug_color: Color
    stretch: number

-- Widget decl:
    parent: Widget
    childs: { Widget }
    pos: Vector2
    margin: Margin
    size: Vector2
    size_policy: SizePolicy
    addItem: function(Layout, WidgetHeir)
    setMargin: function(Layout, Margin)
    setGlobalPos: function(Layout, Vector2)
    hide: function(Layout)
end

-- Layout(parent: WidgetHeir, align_type: LayoutType, size: Vector2, size_policy: SizePolicy)
-- Layout(parent: WidgetHeir, align_type: LayoutType, size_policy: SizePolicy)
function Layout:new(parent: WidgetHeir, align_type: LayoutType, size: Vector2 | SizePolicy, size_policy: SizePolicy): Layout
    if type(size) == "string" then
        size_policy = size as SizePolicy
        size = nil
    end

    local self = extends(Layout, Widget, { parent, size, size_policy })

    self.is_debug = false
    self.type = align_type
    self.stretch = 16

    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:addItem(item_arg: WidgetHeir)
    local item: Widget = item_arg as Widget

    item.parent = self as Widget
    table.insert(self.childs, item)

    item:align()
    item:updateSelf()
end

function Layout:align()
    if self.type == "HBox" then
        local total_width = self.size.x - self.margin.left - self.margin.right
        local current_x = self.pos.x + self.margin.left
        local capacity = total_width + self.stretch
        local warp_count = 0

        for _, child in ipairs(self.childs) do
            child.is_outside_size = true

            if child.size_policy == "Maximum" then
                warp_count = warp_count + 1
            else
                capacity = capacity - child.size.x - self.stretch
            end
        end

        for _, child in ipairs(self.childs) do
            if child.size_policy == "Maximum" then
                child.size.x = (capacity / warp_count) - self.margin.left - self.margin.right
                capacity = capacity - child.size.x
                warp_count = warp_count - 1
            end

            if child.size_policy ~= "Fixed" then
                child.size.y = self.size.y - self.margin.top - self.margin.bottom
            end

            child.pos.x = current_x
            current_x = current_x + child.size.x + self.stretch
            
            if child:getPos().x >= total_width then
                child:hide()
            end
        end
    end

    if self.type == "VBox" then error("not impl") end
    if self.type == "Grid" then error("not impl") end
end

function Layout:show()
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
        child:show()
    end
end

function Layout:getStretch(): number
    return self.stretch
end

function Layout:setStretch(stretch: number)
    self.stretch = stretch
end

function Layout:turnDebugLines(is_debug: boolean)
    self.is_debug = is_debug == nil and true or is_debug
end