local debug = {}

debug.print = function(x)
    local function format(x)
        if type(x) == "table" then
            local str = "{ "
            for i, v in pairs(x) do
                if type(i) ~= "number" then
                    i = "\"".. i.. "\""
                end
                
                str = str.. " [".. i.."] = ".. format(v).. ", "
            end
            
            return str .. " }"
        else
            return tostring(x)
        end
    end

    print(format(x))
end

return debug