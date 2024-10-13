require("oop")
require("window")

--global dbg = require("externals/debugger/debugger") as Debugger

global record Application is IWidget
    title: string
end

function Application:new(title: string, size?: Vector2): Application
    local self = extends(Application, "Application", Widget, nil, "Maximum", nil)
    
    if size then
        self.size = size
        window.set_size(self.size.x as integer, self.size.y as integer)
    else
        self.size = window.get_size()
    end

    self.title = title
    window.set_title(self.title)

    connect("window_resized", function()
        local new_size = window.get_size()
        self.size.x = new_size.x
        self.size.y = new_size.y
    end)

    return self
end

-- override
function Application:render()
    for _, child in ipairs(self.childs) do
        child:render()
    end
end