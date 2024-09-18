global type Printable = record
    tostring: function(Printable): string
end

local function to_string(val: any): string
    if type(val) == "table" and (val as Printable).tostring then
        return (val as Printable):tostring()
    else
        return tostring(val)
    end
end

global function format(fmt: string, ...: any): string
    local res = ""
    local args = { ... }
    local count: integer = 1

    for i = 1, #fmt do
        if fmt:sub(i, i) == '%' then
            if count <= #args then
                res = res .. to_string(args[count])
                count = count + 1
            end
        else
            res = res .. fmt:sub(i, i)
        end
    end

    return res
end

global function printf(fmt_or_v: any, ...: any): string
    if type(fmt_or_v) == "string" then
        io.write(format(fmt_or_v as string, ...))
    else
        io.write(to_string(fmt_or_v))
    end

    io.write('\n')
    io.flush()
end