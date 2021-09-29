local Symbol = {}



function Symbol.new(id, scope)
    return setmetatable({
        id = id,
        scope = scope or "default",
    }, {
        __index = Symbol,
        __eq = function(self, other)
            return self:isA(other)
        end,
        __tostring = function(self)
            return ("Symbol(%s/%s)"):format(self.scope, self.id)
        end
    })
end


function Symbol:isA(other)
    return (self.id == other.id) and (self.scope == other.scope)
end



return Symbol