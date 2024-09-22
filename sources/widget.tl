require("sizepolicy")
require("signal")
require("oop")

--global dbg = require("externals/debugger/debugger") as Debugger

global type WidgetHeir = any

global record Widget
    parent: Widget
    childs: { Widget }

    pos: Vector2
    is_visible: boolean

    size: Vector2
    size_policy: SizePolicy

-- force decl:
    setParent: function<Self>(Self, WidgetHeir)
    setSize: function<Self>(Self, Vector2)
    setPos: function<Self>(Self, Vector2)
    update: function<Self>(Self)
    getSize: function<Self>(Self): Vector2
end

function Widget:new(parent: WidgetHeir, size: Vector2, size_policy: SizePolicy): Widget
    local self = create(Widget, "Widget")

    self.pos = Vector2:new(0, 0)
    self.is_visible = true

    self.size = size and size:copy() or Vector2:new(100, 100)
    self.size_policy = size_policy or "Fixed"

    self.childs = {}
    self:setParent(parent)

    connect("window_resized", function() self:update() end)
    connect("startup", function() self:update() end)
    
    return self
end

function Widget:addChild(widget_heir: WidgetHeir)
    if not widget_heir then return end
    local widget = widget_heir as Widget

    widget.parent = self
    table.insert(self.childs, widget)

    self:update()
end

function Widget:setParent(widget_heir: WidgetHeir)
    if not widget_heir then return end
    local widget = widget_heir as Widget

    widget:addChild(self)
end

function Widget:setLayout(widget_heir: WidgetHeir)
    if not widget_heir then return end
    local layout = widget_heir as Widget

    layout:setParent(self)
    layout:setSize(self.size) -- by ref
    layout:setPos(self.pos) -- by ref
end

-- pure virtual:
function Widget:render() end
function Widget:update() end

-- virtual:
function Widget:tostring(): string
    return format("Widget(pos: %, size: %, policy: \"%\")", self.pos, self.size, self.size_policy)
end

function Widget:getSize(): Vector2
    return self.size:copy()
end

function Widget:setSize(size: Vector2)
    self.size = size
    self:update()
end

function Widget:getPos(): Vector2
    return self.pos:copy()
end

function Widget:setPos(pos: Vector2)
    self.pos = pos
    self:update()
end

function Widget:hide()
    self.is_visible = false
end

function Widget:show()
    self.is_visible = true
end

function Widget:isVisible(): boolean
    return self.is_visible
end

function Widget:getPosition(): Vector2
    return self.pos:copy()
end

function Widget:setPosition(pos: Vector2)
    self.pos = pos
end

-- virtual:
function Widget:isWidthFlexible(): boolean
    return self.size_policy == "Maximum"
end

-- virtual:
function Widget:isHeightFlexible(): boolean
    return self.size_policy == "Maximum"
end

function Widget:itemsSize(): integer
    return #self.childs
end

function Widget:at(index: integer): Widget
    local widget = self.childs[index]
    if not widget then
        error(format("Widget:at(): out of bounds, size: %, but try index: %", #self.childs, index))
    end

    return widget
end

function Widget:indexOf(widget_heir: WidgetHeir): integer
    if not widget_heir then return -1 end
    local widget = widget_heir as Widget

    for i, child in ipairs(self.childs) do
        if child == widget then return i end
    end

    return -1
end