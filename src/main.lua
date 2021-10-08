--LUANIX INIT
--equivalent to CPU initial boot instructions

local exitCodes = {
    [0x00] = "SUCCESS",
    [0x01] = "NO BOOTABLE DISK OR VOLUME DETECTED",
    [0x02] = "NO BOOT PROGRAM DETECTED",
    [0x03] = "ERROR IN BOOT PROGRAM",
}

local biosFile = io.open("onboard/bios.vhw", "r")
if not biosFile then
    io.write("\n", "## CPU EXCEPTION ## BIOS CHIP NOT FOUND", "\n")
end

local biosText = biosFile:read("*a")
if not biosText then
    io.write("\n", "## CPU EXCEPTION ## ENCOUNTERED ERROR READING BIOS FILE", "\n")
end

local bios = load(biosText)
if type(bios) ~= "function" then
    io.write("\n", "## CPU EXCEPTION ## ENCOUNTERED ERROR PARSING BIOS TEXT ## SYNTAX ERROR?", "\n")
end

biosFile:close()

local success, returns = pcall(bios)
if success then
    local code = returns
    io.write("\n", "## VIRTUAL CPU TERMINATED WITH EXIT MESSAGE/CODE:", "\n")
    io.write(tostring(code), " - ", tostring(exitCodes[code]), "\n")
    io.write("\n", "## YOU MAY CLOSE THIS TAB. ##", "\n")
else
    local err = returns
    io.write("\n", "## SYSTEM CRASH", "\n", tostring(err), "\n")
end