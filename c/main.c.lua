local attachedItems = {}
local isResourceStopping = false
local hashToConfig = {}
local nameToHash = {}
local resourceName = GetCurrentResourceName()
local lastAttachTime = {}
local weaponStates = {}
local DEBOUNCE_TIME = 1000

local function InitializeLookupTables()
    for _, categoryItems in pairs(Config.options) do
        for _, item in ipairs(categoryItems) do
            local hash = GetHashKey(item.hashName)
            if hash then
                item.hash = hash
                hashToConfig[hash] = item
                nameToHash[item.hashName] = hash
            end
        end
    end
end

local function IsPedMale(ped)
    return Citizen.InvokeNative(0x95B8E397B8F4360F, ped)
end

local function GetCorrectBone(config, ped)
    local gender = IsPedMale(ped) and 'male' or 'female'
    if gender == 'female' and config.bone[gender] == false then
        return config.bone.male
    end
    
    return config.bone[gender]
end

local function GetCorrectOffset(config, ped)
    local gender = IsPedMale(ped) and 'male' or 'female'
   if gender == 'female' and config.offset[gender] == false then
        return config.offset.male
    end
    
    return config.offset[gender]
end

local function GetBoneIndex(ped, boneName)
    return GetEntityBoneIndexByName(ped, boneName)
end

local function GetPlayerIdentifier()
    return GetPlayerServerId(PlayerId())
end

-- Modify event names to include player ID
local function GetEventName(base, playerId)
    return string.format('%s:%s:%s', resourceName, base, playerId)
end

local function AttachItemToBelt(config)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerIdentifier()
    
    if attachedItems[config.hash] or isResourceStopping then 
        RemoveItemFromBelt(config.hash)
        Wait(200)
    end
    
    if not HasModelLoaded(config.model) then
        RequestModel(config.model)
        while not HasModelLoaded(config.model) and not isResourceStopping do
            Wait(10)
        end
    end
    
    if not isResourceStopping then
        local offset = GetCorrectOffset(config, playerPed)
        local bone = GetCorrectBone(config, playerPed)
        
        attachedItems[config.hash] = CreateObject(config.model, 0.0, 0.0, 0.0, true, true, true)
        local entity = attachedItems[config.hash]
        
        if DoesEntityExist(entity) then
            NetworkRegisterEntityAsNetworked(entity)
            Wait(1000)
            local netId = NetworkGetNetworkIdFromEntity(entity)
            
            if NetworkDoesNetworkIdExist(netId) then
                SetEntityAsMissionEntity(entity, true, true)
                
                -- Use player-specific event
                TriggerServerEvent(GetEventName('server:AttachItem', playerId), netId, config.hash, playerId)
                
                AttachEntityToEntity(
                    entity,
                    playerPed,
                    GetBoneIndex(playerPed, bone),
                    offset.x, offset.y, offset.z,
                    offset.pitch, offset.roll, offset.yaw,
                    true, true, false, true, 1, true
                )
            else
                DeleteObject(entity)
            end
        end
    end
end

-- Modify RemoveItemFromBelt function
local function RemoveItemFromBelt(hash)
    if attachedItems[hash] then
        if DoesEntityExist(attachedItems[hash]) then
            local netId = NetworkGetNetworkIdFromEntity(attachedItems[hash])
            if NetworkDoesNetworkIdExist(netId) then
                -- Use player-specific event
                TriggerServerEvent(GetEventName('server:RemoveItem', GetPlayerIdentifier()), netId, hash)
            end
        end
        DeleteObject(attachedItems[hash])
        attachedItems[hash] = nil
    end
end

RegisterNetEvent(resourceName..':client:UpdateAttachment')
AddEventHandler(resourceName..':client:UpdateAttachment', function(netId, hash, sourcePlayer)
    -- Only process if it's meant for another player
    if sourcePlayer ~= GetPlayerIdentifier() then
        if NetworkDoesNetworkIdExist(netId) then
            local entity = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(entity) then
                local config = hashToConfig[hash]
                if config then
                    local targetPed = GetPlayerPed(GetPlayerFromServerId(sourcePlayer))
                    if DoesEntityExist(targetPed) then
                        local offset = GetCorrectOffset(config, targetPed)
                        local bone = GetCorrectBone(config, targetPed)
                        
                        -- Create a new object for this player
                        local newEntity = CreateObject(config.model, 0.0, 0.0, 0.0, true, true, true)
                        if DoesEntityExist(newEntity) then
                            NetworkRegisterEntityAsNetworked(newEntity)
                            SetEntityAsMissionEntity(newEntity, true, true)
                            
                            AttachEntityToEntity(
                                newEntity,
                                targetPed,
                                GetBoneIndex(targetPed, bone),
                                offset.x, offset.y, offset.z,
                                offset.pitch, offset.roll, offset.yaw,
                                true, true, false, true, 1, true
                            )
                            
                            -- Store with player-specific key
                            attachedItems[hash .. '_' .. sourcePlayer] = newEntity
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent(resourceName..':client:RemoveAttachment')
AddEventHandler(resourceName..':client:RemoveAttachment', function(netId, hash)
    if NetworkDoesNetworkIdExist(netId) then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(entity) then
            DeleteObject(entity)
            if attachedItems[hash] == entity then
                attachedItems[hash] = nil
            end
        end
    end
end)

CreateThread(function()
    if not resourceName == 'bln_belt_attachments' then return end
    InitializeLookupTables()
    
    while not isResourceStopping do
        local playerPed = PlayerPedId()
        local _, currentWeapon = GetCurrentPedWeapon(playerPed, true)
        local currentTime = GetGameTimer()
        
        for hash, config in pairs(hashToConfig) do
            local hasWeapon = HasPedGotWeapon(playerPed, hash, false)
            local isEquipped = currentWeapon == hash
            local currentState = hasWeapon and not isEquipped
            
            if weaponStates[hash] ~= currentState and 
               (not lastAttachTime[hash] or (currentTime - lastAttachTime[hash]) > DEBOUNCE_TIME) then
                
                if currentState then
                    if not attachedItems[hash] then
                        AttachItemToBelt(config)
                    end
                else
                    RemoveItemFromBelt(hash)
                end
                
                weaponStates[hash] = currentState
                lastAttachTime[hash] = currentTime
            end
        end
        
        Wait(250)
    end
end)

TriggerServerEvent(GetEventName('server:RequestAttachments', GetPlayerIdentifier()))

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    isResourceStopping = true
    for hash, _ in pairs(attachedItems) do
        RemoveItemFromBelt(hash)
    end
end)