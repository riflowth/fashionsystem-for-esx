ESX = nil
TriggerEvent('esx:getSharedObject', function(object) ESX = object end)

local fashionCache = {}

--- Register usable item by ESX utility, this for registering fashion item for using
--- Load all fashions from the config
for fashionName, _ in pairs(config) do
    ESX.RegisterUsableItem(fashionName, function(playerId)
        TriggerClientEvent('fashionsystem:toggle:' .. fashionName, playerId)
    end)
end

--- Cache prop entity for management, ex: remove when player disconnected
--- @param prop entity id of prop object
--- @param isCache a boolean, true for caching, false for uncaching
RegisterNetEvent('fashionsystem:cacheProp')
AddEventHandler('fashionsystem:cacheProp', function(prop, isCache)
    local playerId = source
    prop = NetworkGetEntityFromNetworkId(prop)
    if isCache then
        -- Allocate new memory for the table
        if fashionCache[playerId] == nil then fashionCache[playerId] = {} end
        table.insert(fashionCache[playerId], prop)
    else
        table.remove(fashionCache[playerId], GetFashionIndex(playerId, prop))
        -- Free memory of the table
        if #fashionCache[playerId] == 0 then fashionCache[playerId] = nil end
    end
end)

--- Delete prop entities when player disconnected from the server
AddEventHandler('playerDropped', function()
    local playerId = source
    if fashionCache[playerId] ~= nil then
        for i = 1, #fashionCache[playerId] do
            DeleteEntity(fashionCache[playerId][i])    
        end
    end
end)

--- Utility function to get fashion index on fashionCache table
function GetFashionIndex(playerId, prop)
    for i = 1, #fashionCache[playerId] do
        if fashionCache[playerId][i] == prop then
            return i
        end
    end
end