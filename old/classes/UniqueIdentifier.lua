local UniqueIdentifier = {__index = UniqueIdentifier}



function UniqueIdentifier.new()
    return setmetatable({
        _highest = 0,
        _holes = {},
    }, UniqueIdentifier)
end


function UniqueIdentifier:get()
    local id = table.remove(self._holes, 1) --self._holes
    if not id then
        self._highest = self._highest + 1
        id = self._highest
    else
        --table.remove(self._holes, 1)
    end

    return id
end


function UniqueIdentifier:remove(id)
    if id < self._highest then
        table.insert(self._holes, id)
        table.sort(self._holes)
    else
        repeat
            self._highest = self._highest - 1
            local empty = self._holes[#self._holes] == self._highest
            if empty then
                table.remove(self._holes)
            end
        until not empty
    end
end



return UniqueIdentifier