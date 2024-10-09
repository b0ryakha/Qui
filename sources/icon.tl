require("widget")
require("oop")

--global dbg = require("externals/debugger/debugger") as Debugger

global record Icon
    sprite: Sprite

-- Widget decl:
    pos: Vector2
    size: Vector2
    isVisible: function<Self>(Self): boolean
    update: function<Self>(Self)
end

-- Icon(parent: WidgetHeir, path: string, size: Vector2, size_policy: SizePolicy)
-- Icon(parent: WidgetHeir, path: string, size: Vector2)
function Icon:new(parent: WidgetHeir, path: string, size: Vector2, size_policy: SizePolicy): Icon
    local self = extends(Icon, "Icon", Widget, parent, size, size_policy)

    self.sprite = Sprite:new(path, self.size.x as integer, self.size.y as integer)

    return self
end

-- override:
function Icon:update()
    if not self.sprite then return end

    self.sprite:set_pos(self.pos.x as integer, self.pos.y as integer)
    self.sprite:set_size(self.size.x as integer, self.size.y as integer)
end

-- override:
function Icon:render()
    if not self:isVisible() then return end
    
    render.sprite(self.sprite)
end

function Icon:setColor(color: Color)
    if not self.sprite then return end
    
    self.sprite:set_color(color)
end