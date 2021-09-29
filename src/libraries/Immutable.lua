local Symbol = require("./classes/Symbol")



local Immutable = {}
Immutable.Dictionary = {}
Immutable.List = {}

Immutable.None = Symbol.new("None")



function Immutable.Dictionary.Join(...)
	local newDictionary = {}

	for _, dictionary in ipairs({ ... }) do
		if typeof(dictionary) ~= "table" then
			error("non dictionary to Immutable.Dictionary.Join")
		end

		for key, value in pairs(dictionary) do
			if value == Immutable.None then
				newDictionary[key] = nil
			else
				newDictionary[key] = value
			end
		end
	end

	return newDictionary
end

function Immutable.Dictionary.DeepJoin(base, patch)
	local newDictionary = Immutable.Dictionary.Join(base)

	for key, value in pairs(patch) do
		if type(value) == "table" then
			if newDictionary[key] == nil then
				newDictionary[key] = value
			else
				newDictionary[key] = Immutable.Dictionary.DeepJoin(
					newDictionary[key],
					value
				)
			end
		else
			if value == Immutable.None then
				value = nil
			end

			newDictionary[key] = value
		end
	end

	return newDictionary
end



function Immutable.List.Join(...)
	local newList = {}

	for _, list in ipairs({ ... }) do
		if typeof(list) ~= "table" then
			error("non table passed to Immutable.List.Join")
		end

		for _, value in ipairs(list) do
			table.insert(newList, value)
		end
	end

	return newList
end


function Immutable.List.Shuffle(list, rng)
	local newList = Immutable.List.Join(list)

	rng = rng or Random.new()

	for index = #list, 1, -1 do
		local swapIndex = rng:NextInteger(0, index)
		newList[index], newList[swapIndex] = newList[swapIndex], newList[index]
	end

	return newList
end


function Immutable.List.Remove(list, index)
	local newList = {}

	for otherIndex, value in ipairs(list) do
		if index ~= otherIndex then
			table.insert(newList, value)
		end
	end

	return newList
end



return Immutable