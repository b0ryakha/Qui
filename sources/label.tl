require("cachedcolor")
require("cachedfont")
require("widget")
require("oop")

global record Label
    text: string
    text_font: Font
    text_color: Color

-- force decl:
    setFont: function<Self>(Self, Font)

-- Widget decl:
    parent: Widget
    childs: { Widget }
    pos: Vector2
    size: Vector2
    isVisible: function<Self>(Self): boolean
end

-- Label(parent: WidgetHeir, text: string, color: Color)
-- Label(parent: WidgetHeir, text: string)
function Label:new(parent: WidgetHeir, text: string, color: Color): Label
    local self = extends(Label, "Label", Widget, parent, nil, nil)

    self.text = text or ""
    self:setFont(CachedFont:new("arial.ttf", 20))
    self.text_color = color or CachedColor:new(0, 0, 0)

    return self
end

function Label:setFont(font: Font)
    self.text_font = font
    self.size = render.measure_text(self.text_font, self.text)
end

function Label:getText(): string
    return self.text
end

function Label:setText(text: string)
    self.text = text
    self.size = render.measure_text(self.text_font, self.text)
end

-- override
function Label:render()
    if not self:isVisible() then return end

    render.text(self.pos.x as integer, self.pos.y as integer, self.text_font, self.text, self.text_color)
end