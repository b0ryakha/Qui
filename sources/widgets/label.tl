require("widget")
require("oop")

global record Label is IWidget
    text: string
    color: Color

    font: Font
    measure: Vector2

    is_debug: boolean
    debug_color: Color

-- force decl:
    setFont: function<Self>(Self, Font)
end

function Label:new(parent: IWidget, text?: string, color?: Color): Label
    local self = extends(Label, "Label", Widget, parent)

    self.text = text or ""
    self.color = color or CachedColor:new(0, 0, 0)

    self.is_debug = false
    self.debug_color = CachedColor:new(cmath.rand_int(150, 255), cmath.rand_int(20, 100), cmath.rand_int(20, 100), 100)

    self:setFont(CachedFont:new("Arial.ttf", 18))
    self.size = self.measure:copy()
    
    connect("new_frame", function() self:renderTooltip() end)

    return self
end

-- override
function Label:render()
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

    render.text(self.pos.x as integer, self.pos.y as integer, self.font, self.text, self.color)
end

function Label:setFont(font: Font)
    self.font = font
    self.measure = render.measure_text(self.font, self.text)
end

function Label:getText(): string
    return self.text
end

function Label:setText(text: string)
    self.text = text
    self.measure = render.measure_text(self.font, self.text)
end

function Label:turnDebug(is_debug?: boolean)
    self.is_debug = is_debug == nil and true or is_debug
end

function Label:setSize(size: Vector2)
    self.size = size:copy()
end

function Label:getSize(): Vector2
    return self.size
end