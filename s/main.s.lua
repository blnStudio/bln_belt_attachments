local resourceName = GetCurrentResourceName()
local activeAttachments = {}

local function GetEventName(base, playerId)
    return string.format('%s:%s:%s', resourceName, base, playerId)
end

RegisterNetEvent(resourceName..':server:AttachItem')
AddEventHandler(resourceName..':server:AttachItem', function(netId, hash, sourcePlayer)
    local eventName = GetEventName('client:UpdateAttachment', sourcePlayer)
    TriggerClientEvent(eventName, -1, netId, hash, sourcePlayer)
end)

RegisterNetEvent(resourceName..':server:RemoveItem')
AddEventHandler(resourceName..':server:RemoveItem', function(netId, hash)
    local eventName = GetEventName('client:RemoveAttachment', source)
    TriggerClientEvent(eventName, -1, netId, hash)
end)

RegisterServerEvent(resourceName..':server:RequestAttachments')
AddEventHandler(resourceName..':server:RequestAttachments', function()
    local src = source
    for netId, data in pairs(activeAttachments) do
        if netId then
            TriggerClientEvent(resourceName..':client:UpdateAttachment', src, netId, data.hash, data.source)
        else
            activeAttachments[netId] = nil
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        activeAttachments = {}
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    for netId, data in pairs(activeAttachments) do
        if data.source == src then
            activeAttachments[netId] = nil
            TriggerClientEvent(resourceName..':client:RemoveAttachment', -1, netId, data.hash)
        end
    end
end)