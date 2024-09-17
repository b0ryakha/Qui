global type Margin = record
    left: number
    right: number
    top: number
    bottom: number
end
    
function Margin:new(left: number, right: number, top: number, bottom: number): Margin
    local self: Margin = setmetatable({}, { __index = Margin })
    
    self.left = left
    self.right = right
    self.top = top
    self.bottom = bottom
    
    return self
end

function Margin:copy(): Margin
    return Margin:new(self.left, self.right, self.top, self.bottom)
end