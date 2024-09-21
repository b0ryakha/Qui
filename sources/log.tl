require("format")

global function printf(fmt_or_v: any, ...: any): string
    io.write(format((fmt_or_v as string) .. '\n', ...))
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