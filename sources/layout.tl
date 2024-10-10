require("widget")
require("cachedcolor")
require("oop")
require("margin")
require("log")

global enum LayoutType
    "HBox" "VBox" "Grid"
end

global record Layout is IWidget
    type: LayoutType
    margin: Margin
    stretch: number

    is_debug: boolean
    debug_color: Color
end

function Layout:new(parent: IWidget, align_type: LayoutType, size_policy?: SizePolicy, size?: Vector2): Layout
    local self = extends(Layout, "Layout", Widget, parent, size_policy or "Maximum", size)

    if typeof(self.parent) ~= "Layout" then
        self.parent:setLayout(self)
    end

    self.type = align_type
    self.margin = Margin:new(8, 8, 8, 8)
    self.stretch = 16

    self.is_debug = false
    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:addItem(item: IWidget)
    if not item then
        warning("Layout: Cannot add a nil item")
        return
    end

    self:addChild(item)
end

-- private:
function Layout:warp(child: IWidget)
    if child.size_policy == "Fixed" then return end

    local right_edge = self.pos.x + self.size.x - self.margin.right
    local bottom_edge = self.pos.y + self.size.y - self.margin.bottom

    -- contract:
    if (child.pos.x + child.size.x) >= right_edge then
        child.size.x = child.size.x - (child.pos.x + child.size.x - right_edge)
    end
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
        if child:isWidthFlexible() then
            warp_count = warp_count + 1
        else
            flexible_width = flexible_width - child.size.x
        end
    end

    if warp_count > 0 then
        local width_per_child = flexible_width / warp_count

        for _, child in ipairs(self.childs) do
            if child:isWidthFlexible() then
                child.size.x = width_per_child
            end
            
            if child:isHeightFlexible() then
                child.size.y = self.size.y - self.margin.top - self.margin.bottom
            end
        end
    end

    local current_x = self.pos.x + self.margin.left

    for _, child in ipairs(self.childs) do
        child.pos.x = current_x
        child.pos.y = self.pos.y + self.margin.top

        current_x = current_x + child.size.x + self.stretch
    end
end

-- private:
function Layout:verticalAlign()
    local total_height = self.size.y - self.margin.top - self.margin.bottom
    local flexible_height = total_height
    local warp_count = 0

    for _, child in ipairs(self.childs) do
        if child:isHeightFlexible() then
            warp_count = warp_count + 1
        else
            flexible_height = flexible_height - child.size.y
        end
    end

    if warp_count > 0 then
        local height_per_child = flexible_height / warp_count

        for _, child in ipairs(self.childs) do
            if child:isWidthFlexible() then
                child.size.x = self.size.x - self.margin.left - self.margin.right
            end

            if child:isHeightFlexible() then
                child.size.y = height_per_child
            end
        end
    end

    local current_y = self.pos.y + self.margin.top

    for _, child in ipairs(self.childs) do
        child.pos.x = self.pos.x + self.margin.left
        child.pos.y = current_y
        
        current_y = current_y + child.size.y + self.stretch
    end
end

function Layout:setStretch(stretch: number)
    self.stretch = stretch
end

function Layout:turnDebug(is_debug?: boolean)
    self.is_debug = is_debug == nil and true or is_debug
end

function Layout:getMargin(): Margin
    return self.margin:copy()
end

function Layout:setMargin(margin: Margin)
    self.margin = margin:copy()
end

-- override:
function Layout:update()
    if self.type == "HBox" then self:horizontalAlign() end
    if self.type == "VBox" then self:verticalAlign() end
    if self.type == "Grid" then error("not impl") end

    for _, child in ipairs(self.childs) do
        self:warp(child)
        child:update()
    end
end

-- override
function Layout:render()
    if not self.is_visible then return end

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