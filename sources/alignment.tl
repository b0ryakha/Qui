require("oop")

global enum HAlign "Left" "Right" "Center" end
global enum VAlign "Top" "Bottom" "Center" end

global record Alignment
    h: HAlign
    v: VAlign
end

function Alignment:new(h: HAlign, v?: VAlign): Alignment
    local self = create(Alignment, "Alignment")

    self.h = h
    self.v = v or h
    
    return self
end