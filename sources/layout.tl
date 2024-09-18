require("widget")
require("cachedcolor")
require("oop")

global enum LayoutType
    "HBox" "VBox" "Grid" "Stack"
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
    setSizePolicy: function(Layout, SizePolicy)
    align: function(Layout)
    setMargin: function(Layout, Margin)
    setGlobalPos: function(Layout, Vector2)
    setSize: function(Layout, Vector2)
    hide: function(Layout)
end

function Layout:new(parent: WidgetHeir, align_type: LayoutType, size: Vector2, size_policy: SizePolicy): Layout
    local self = extends(Layout, Widget, { parent, size, size_policy })

    self.is_debug = false
    self.type = align_type
    self.stretch = 16

    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:update()
    if self.type == "HBox" then
        local p_width = self.parent and (self.parent.size.x - self.parent.margin.left - self.parent.margin.right) or window.get_size().x
        local capacity = p_width - self.stretch * (#self.childs - 1)
        local childs_len: integer = #self.childs

        for i = 1, childs_len do
            local child = self.childs[i]
            local prev_child = self.childs[i - 1]
            local new_pos = (i == 1) and Vector2:new(self.pos.x + self.margin.left, self.pos.y + self.margin.top) or prev_child:getGlobalPos()
            local prev_child_size = (i == 1) and Vector2:new(0, 0) or prev_child:getSize()
            local stretch = (i == 1) and 0 or self.stretch

            if child:getSizePolicy() ~= "Fixed" then
                local target_width = capacity / (childs_len - (i - 1))
                child:setSize(Vector2:new(
                    target_width - self.margin.left - self.margin.right,
                    self.size.y - self.margin.top - self.margin.bottom
                ))
            end

            new_pos.x = new_pos.x + prev_child_size.x + stretch
            capacity = capacity - child:getSize().x
            child:setGlobalPos(new_pos)
            
            if child:getPos().x + child:getSize().x >= p_width then
                child:hide()
            end
        end
    end

    if self.type == "VBox" then error("not impl") end
    if self.type == "Grid" then error("not impl") end
    if self.type == "Stack" then error("not impl") end
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