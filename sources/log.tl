require("format")

-- TODO: for 1 value

global function printf(fmt: string, ...: any): string
    io.write(format(fmt .. '\n', ...))
    io.flush()
end

global function warning(fmt: string, ...: any)
    local yellow = "\027[33m"
    local standart = "\027[0m"
    printf("[%WARNING%]: %", yellow, standart, format(fmt, ...))
end

global function info(fmt: string, ...: any)
    printf("[INFO]: %", format(fmt, ...))
end