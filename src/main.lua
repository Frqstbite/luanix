--equivalent to CPU initial boot instructions

local biosFile = io.open("bios.vhw", "r")
if not biosFile then
    io.write("\n", "## CPU EXCEPTION ## BIOS CHIP NOT FOUND", "\n")
end

local biosText = biosFile:read("*a")
if not biosText then
    io.write("\n", "## CPU EXCEPTION ## ENCOUNTERED ERROR READING BIOS FILE", "\n")
end

local bios = loadstring(biosText)
if type(bios) == nil then
    io.write("\n", "## CPU EXCEPTION ## ENCOUNTERED ERROR PARSING BIOS TEXT ## SYNTAX ERROR?", "\n")
end

biosFile:close()

local success, returns = pcall(bios)
if success then
    local msg = returns
    io.write("\n", "## VIRTUAL CPU TERMINATED WITH EXIT MESSAGE/CODE", "\n", msg, "\n")
    io.write("\n", "## YOU MAY CLOSE THIS TAB. ##", "\n")
else
    local err = returns
    io.write("\n", "## FATAL ERROR IN SYSTEM", "\n", tostring(err), "\n")
end