require("format")

-- TODO: for 1 value

global function printf(fmt: string, ...: any): string
    io.write(format(fmt .. '\n', ...))
    io.flush()
end

global function warning(fmt: string, ...: any)
    local yellow = "\027[33m"
    local white = "\027[37m"
    printf("[%WARNING%]: %", yellow, white, format(fmt, ...))
end

global function info(fmt: string, ...: any)
    printf("[INFO]: %", format(fmt, ...))
end