local resourceName = GetCurrentResourceName()
local activeAttachments = {}

RegisterServerEvent(resourceName..':server:AttachItem')
AddEventHandler(resourceName..':server:AttachItem', function(netId, hash, sourcePlayer)
    if netId then
        activeAttachments[netId] = {
            hash = hash,
            source = sourcePlayer
        }
        TriggerClientEvent(resourceName..':client:UpdateAttachment', -1, netId, hash, sourcePlayer)
    end
end)

RegisterServerEvent(resourceName..':server:RemoveItem')
AddEventHandler(resourceName..':server:RemoveItem', function(netId, hash)
    if activeAttachments[netId] then
        activeAttachments[netId] = nil
        TriggerClientEvent(resourceName..':client:RemoveAttachment', -1, netId, hash)
    end
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