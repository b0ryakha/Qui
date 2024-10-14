require("sizepolicy")
require("signal")
require("oop")
require("format")
require("cachedfont")
require("cachedcolor")

global interface IWidget
    parent: IWidget
    childs: { IWidget }

    pos: Vector2
    is_visible: boolean

    size: Vector2
    min_size: Vector2
    size_policy: SizePolicy
    tooltip: string

    addChild: function<Self>(Self, IWidget)
    setParent: function<Self>(Self, IWidget)
    setLayout: function<Self>(Self, IWidget)
    renderTooltip: function<Self>(Self, number)
    setTooltip: function<Self>(Self, string)
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
    self.min_size = self.size:copy()
    self.size_policy = size_policy or "Fixed"
    self.tooltip = ""

    self.childs = {}
    self:setParent(parent)

    connect("window_resized", function() self:update() end)
    connect("startup", function() self:update() end)
    connect("cursor_stopped", function(data: Data) self:renderTooltip(data.duration as number) end)
    
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

function Widget:renderTooltip(duration: number)
    if duration as number <= 1 then return end
    -- if in bound

    local tooltip: { string : any } = {}
    tooltip.text = self.tooltip
    tooltip.font = CachedFont:new("Arial.ttf", 20)
    tooltip.measure = render.measure_text(tooltip.font as Font, tooltip.text as string)
    tooltip.bg_color = CachedColor:new(220, 220, 220)
    tooltip.color = CachedColor:new(0, 0, 0)
    tooltip.pos = cursor.get_pos()

    render.rectangle(
        (tooltip.pos as Vector2).x as integer,
        (tooltip.pos as Vector2).y as integer,
        (tooltip.measure as Vector2).x as integer,
        (tooltip.measure as Vector2).y as integer,
        tooltip.bg_color as Color
    )

    render.text(
        (tooltip.pos as Vector2).x as integer,
        (tooltip.pos as Vector2).y as integer,
        tooltip.font as Font,
        tooltip.text as string,
        tooltip.color as Color
    )
end

function Widget:setTooltip(tooltip: string)
    self.tooltip = tooltip
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
    return self.size_policy ~= "Fixed"
end

function Widget:isHeightFlexible(): boolean
    return self.size_policy ~= "Fixed"
end

function Widget:itemsCount(): integer
    return #self.childs
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