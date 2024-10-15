require("widget")
require("label")
require("layout")
require("oop")

global record GroupBox is IWidget
    label: Label
    label_offset: integer
    layout: Layout
end

function GroupBox:new(parent: IWidget, size_policy: SizePolicy, title?: string, size?: Vector2): GroupBox
    local self = extends(GroupBox, "GroupBox", Widget, parent, size_policy, size)

    self.label = Label:new(nil, title or "")
    self.label:setPos(self.pos) -- by ref
    self.label_offset = cmath.round(self.pos.y + self.label.measure.y * 1.5)

    self.layout = Layout:new(self, "VBox")
    self.layout:setPos(self.pos) -- by ref
    self.layout:setSize(self.size) -- by ref
    self.layout.margin.top = self.layout.margin.top + self.label_offset

    return self
end

-- override:
function GroupBox:addChild(widget: IWidget)
    if not widget then return end
    if not self.layout then return end

    widget.parent = self.layout
    table.insert(self.layout.childs, widget)
end

-- override:
function GroupBox:render()
    if not self.is_visible then return end

    self.label:render()

    render.outline_rectangle(
        self.pos.x as integer,
        self.pos.y as integer + self.label_offset,
        self.size.x as integer,
        self.size.y as integer,
        1,
        CachedColor:new(150, 150, 150),
        1
    )

    self.layout:childsRender()
end