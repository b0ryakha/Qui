require("widget")
require("cachedcolor")
require("oop")

global enum LayoutType
    "HBox" "VBox" "Grid" "Stack"
end

global type Layout = record
    is_debug: boolean
    type: LayoutType
    debug_color: Color
    offset: number

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
end

function Layout:new(parent: WidgetHeir, align_type: LayoutType, size: Vector2, size_policy: SizePolicy): Layout
    local self = extends(Layout, Widget, { parent, size, size_policy })

    self.is_debug = false
    self.type = align_type
    self.offset = 16

    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    return self
end

function Layout:update()
    -- TODO: impl
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

function Layout:turnDebugLines(is_debug: boolean)
    self.is_debug = is_debug == nil and true or is_debug
end