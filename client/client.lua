local usingFashion = {} -- Table of key-value pairs of fashio name and prop entity

--- Register events for toggling fashion from the config
for fashionName, data in pairs(config) do
    RegisterNetEvent('fashionsystem:toggle:' .. fashionName)
    AddEventHandler('fashionsystem:toggle:' .. fashionName, function()
        if IsUsingFashion(fashionName) then
            local prop = usingFashion[fashionName]

            -- Implement your code here
            exports.pNotify:SendNotification({
                text = 'You has unequipped ' .. fashionName,
                type = 'success',
                timeout = 2000,
                layout = 'bottomCenter',
                queue = 'FashionSystem'
            })
            --------------------------

            DeleteObject(prop)
            TriggerServerEvent('fashionsystem:cacheProp', ObjToNet(prop), false)
            usingFashion[fashionName] = nil
        else
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local prop = CreateObject(GetHashKey(fashionName), coords.x, coords.y, coords.z, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, data.bone)

            local fashionCoords = vector3(data.coords[1], data.coords[2], data.coords[3])
            local fashionRotation = vector3(data.rotation[1], data.rotation[2], data.rotation[3])
            
            -- Implement your code here
            exports.pNotify:SendNotification({
                text = 'You has equipped ' .. fashionName,
                type = 'success',
                timeout = 2000,
                layout = 'bottomCenter',
                queue = 'FashionSystem'
            })
            --------------------------

            usingFashion[fashionName] = prop
            TriggerServerEvent('fashionsystem:cacheProp', ObjToNet(prop), true)
            AttachEntityToEntity(prop, playerPed, boneIndex, fashionCoords, fashionRotation, true, true, false, true, 1, true)
        end
    end)
end

--- Check if player using specific given fashion name
--- @param fashionName the string of fashion name that you want to check
--- @return true if player currently use given fashion name
function IsUsingFashion(fashionName)
    for usingFashionName, _ in pairs(usingFashion) do
        if fashionName == usingFashionName then
            return true
        end
    end
    return false
end