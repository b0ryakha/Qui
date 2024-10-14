require("widget")
require("oop")
require("margin")

global enum LayoutType
    "HBox" "VBox" "Grid"
end

global record Layout is IWidget
    type: LayoutType
    margin: Margin
    spacing: number

    is_debug: boolean
    debug_color: Color
end

function Layout:new(parent: IWidget, align_type: LayoutType, size_policy?: SizePolicy, size?: Vector2): Layout
    local self = extends(Layout, "Layout", Widget, parent, size_policy or "Maximum", size)

    if type(self.parent) ~= "Layout" then
        self.parent:setLayout(self)
    end

    self.type = align_type
    self.margin = Margin:new(9, 9, 9, 9)
    self.spacing = 6

    self.is_debug = false
    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:addItem(item: IWidget)
    if not item then
        error("Layout: Cannot add a nil item")
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
    local total_height = self.size.y - self.margin.top - self.margin.bottom
    
    local fixed_width: number = 0
    local warp_count = 0

    for _, child in ipairs(self.childs) do
        if child:isWidthFlexible() then
            warp_count = warp_count + 1
        else
            fixed_width = fixed_width + child.size.x
        end
    end

    local flexible_width = total_width - fixed_width
    local total_children_width: number = 0
    local max_children_count = 0

    for _, child in ipairs(self.childs) do
        if warp_count > 0 and child:isWidthFlexible() then
            local new_width = flexible_width / warp_count
            
            if child.size_policy == "Maximum" then
                child.size.x = math.max(child.min_size.x, new_width)
                max_children_count = max_children_count + 1
            else -- Minimum:
                child.size.x = math.min(child.min_size.x, new_width)
            end
        end
        
        if child:isHeightFlexible() then
            child.size.y = total_height
        end

        if child.size_policy ~= "Maximum" then
            total_children_width = total_children_width + child.size.x
        end
    end

    if max_children_count > 0 then
        local remaining_width = total_width - total_children_width
        local new_width = remaining_width / max_children_count

        for _, child in ipairs(self.childs) do
            if child.size_policy == "Maximum" then
                child.size.x = new_width
                total_children_width = total_children_width + child.size.x
            end
        end
    end

    local current_x = self.pos.x + self.margin.left + (total_width - total_children_width) / 2

    for _, child in ipairs(self.childs) do
        child.pos.x = current_x
        child.pos.y = self.pos.y + self.margin.top + (total_height - child.size.y) / 2

        current_x = current_x + child.size.x + self.spacing
    end
end

-- private:
function Layout:verticalAlign()
    local total_width = self.size.x - self.margin.left - self.margin.right
    local total_height = self.size.y - self.margin.top - self.margin.bottom
    
    local fixed_height: number = 0
    local warp_count = 0

    for _, child in ipairs(self.childs) do
        if child:isHeightFlexible() then
            warp_count = warp_count + 1
        else
            fixed_height = fixed_height + child.size.y
        end
    end

    local flexible_height = total_height - fixed_height
    local total_children_height: number = 0
    local max_children_count = 0

    for _, child in ipairs(self.childs) do
        if warp_count > 0 and child:isHeightFlexible() then
            local new_height = flexible_height / warp_count
            
            if child.size_policy == "Maximum" then
                child.size.y = math.max(child.min_size.y, new_height)
                max_children_count = max_children_count + 1
            else -- Minimum:
                child.size.y = math.min(child.min_size.y, new_height)
            end
        end
        
        if child:isWidthFlexible() then
            child.size.x = total_width
        end

        if child.size_policy ~= "Maximum" then
            total_children_height = total_children_height + child.size.y
        end
    end

    if max_children_count > 0 then
        local remaining_height = total_height - total_children_height
        local new_height = remaining_height / max_children_count

        for _, child in ipairs(self.childs) do
            if child.size_policy == "Maximum" then
                child.size.y = new_height
                total_children_height = total_children_height + child.size.y
            end
        end
    end

    local current_y = self.pos.y + self.margin.top + (total_height - total_children_height) / 2

    for _, child in ipairs(self.childs) do
        child.pos.y = current_y
        child.pos.x = self.pos.x + self.margin.left + (total_width - child.size.x) / 2

        current_y = current_y + child.size.y + self.spacing
    end
end

function Layout:setSpacing(spacing: number)
    self.spacing = spacing
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