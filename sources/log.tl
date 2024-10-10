require("format")

global function printfn(fmt: string, ...: any): string
    io.write(format(fmt .. '\n', ...))
    io.flush()
end

global function warning(...: any)
    local yellow = "\027[33m"
    local standart = "\027[0m"
    printfn(format("[%WARNING%]: %", yellow, standart, string.rep("%  ", #{...})), ...)
end

global function info(...: any)
    printfn(format("[INFO]: %", string.rep("%  ", #{...})), ...)
end