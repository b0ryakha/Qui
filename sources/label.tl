require("cachedcolor")
require("cachedfont")
require("widget")
require("oop")

global record Label is IWidget
    text: string
    text_font: Font
    text_color: Color

-- force decl:
    setFont: function<Self>(Self, Font)
end

function Label:new(parent: IWidget, text?: string, color?: Color): Label
    local self = extends(Label, "Label", Widget, parent)

    self.text = text or ""
    self.text_color = color or CachedColor:new(0, 0, 0)
    self:setFont(CachedFont:new("arial.ttf", 20))

    return self
end

-- override
function Label:render()
    if not self.is_visible then return end
    render.text(self.pos.x as integer, self.pos.y as integer, self.text_font, self.text, self.text_color)
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