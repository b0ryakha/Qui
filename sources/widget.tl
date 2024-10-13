require("sizepolicy")
require("signal")
require("oop")
require("format")

--global dbg = require("externals/debugger/debugger") as Debugger

global interface IWidget
    parent: IWidget
    childs: { IWidget }

    pos: Vector2
    is_visible: boolean

    size: Vector2
    size_policy: SizePolicy

    addChild: function<Self>(Self, IWidget)
    setParent: function<Self>(Self, IWidget)
    setLayout: function<Self>(Self, IWidget)
    getSize: function<Self>(Self): Vector2
    getPos: function<Self>(Self): Vector2
    hide: function<Self>(Self)
    show: function<Self>(Self)
    isVisible: function<Self>(Self): boolean
    itemsCount: function<Self>(Self): integer
    at: function<Self>(Self, integer): IWidget
    indexOf: function<Self>(Self, IWidget): integer

    -- virtual:
    tostring: function<Self>(Self): string
    setSize: function<Self>(Self, Vector2)
    setPos: function<Self>(Self, Vector2)
    isWidthFlexible: function<Self>(Self): boolean
    isHeightFlexible: function<Self>(Self): boolean

    -- pure virtual:
    render: function<Self>(Self)
    update: function<Self>(Self)
end

global record Widget is IWidget end

function Widget:new(parent: IWidget, size_policy: SizePolicy, size: Vector2): Widget
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

function Widget:__tostring(): string
    return format("%(pos: %, size: %, policy: \"%\")", type(self), self.pos, self.size, self.size_policy)
end

function Widget:render() end
function Widget:update() end

function Widget:addChild(widget: IWidget)
    if not widget then return end

    widget.parent = self
    table.insert(self.childs, widget)

    self:update()
end

function Widget:setParent(widget: IWidget)
    if not widget then return end
    widget:addChild(self)
end

function Widget:setLayout(widget: IWidget)
    if not widget then return end

    widget:setParent(self)
    widget:setSize(self.size) -- by ref
    widget:setPos(self.pos) -- by ref
end

function Widget:getSize(): Vector2
    return self.size:copy()
end

function Widget:setSize(size: Vector2)
    if not size then
        error(format("%: Cannot set a nil size", type(self)))
    end

    self.size = size
    self:update()
end

function Widget:getPos(): Vector2
    return self.pos:copy()
end

function Widget:setPos(pos: Vector2)
    if not pos then
        error(format("%: Cannot set a nil pos", type(self)))
    end

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

function Widget:isWidthFlexible(): boolean
    return self.size_policy == "Maximum"
end

function Widget:isHeightFlexible(): boolean
    return self.size_policy == "Maximum"
end

function Widget:itemsCount(): integer
    return self.childs and #self.childs or 0
end

function Widget:at(index: integer): IWidget
    local widget = self.childs[index]
    if not widget then
        error(format("%.at: out of bounds, size: %, but try index: %", type(self), #self.childs, index))
    end

    return widget
end

function Widget:indexOf(widget: IWidget): integer
    if not widget then return -1 end

    for i, child in ipairs(self.childs) do
        if child == widget then return i end
    end

    return -1
end