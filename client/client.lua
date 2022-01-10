ESX = nil
TriggerEvent('esx:getSharedObject', function(instance) ESX = instance end)

local usingFashion = {} -- Table of key-value pairs of fashio name and prop entity

--- Register events for toggling fashion from the config
for fashionName, data in pairs(config) do
    RegisterNetEvent('fashionsystem:toggle:' .. fashionName)
    AddEventHandler('fashionsystem:toggle:' .. fashionName, function()

        local itemLabel = ''
        for _, item in ipairs(ESX.GetPlayerData().inventory) do
            if item.name == fashionName then
                itemLabel = item.label
                break
            end
        end

        if IsUsingFashion(fashionName) then
            local prop = usingFashion[fashionName]

            while not DoesEntityExist(prop) do Citizen.Wait(100) end

            exports.pNotify:SendNotification({
                text = '<span class="red-text">คุณได้ถอด ' .. itemLabel .. '</span>',
                type = 'success',
                timeout = 2000,
                layout = 'bottomCenter',
                queue = 'FashionSystem'
            })

            usingFashion[fashionName] = nil
            TriggerServerEvent('fashionsystem:cacheProp', ObjToNet(prop), false)
            DeleteObject(prop)
        else
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local prop = CreateObject(GetHashKey(fashionName), coords.x, coords.y, coords.z, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, data.bone)

            local fashionCoords = vector3(data.coords[1], data.coords[2], data.coords[3])
            local fashionRotation = vector3(data.rotation[1], data.rotation[2], data.rotation[3])

            while not DoesEntityExist(prop) do Citizen.Wait(100) end

            exports.pNotify:SendNotification({
                text = '<span class="green-text">คุณได้ใส่ ' .. itemLabel .. '</span>',
                type = 'success',
                timeout = 2000,
                layout = 'bottomCenter',
                queue = 'FashionSystem'
            })

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