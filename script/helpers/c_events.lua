--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_TOURNIQUET, function(bodyPart, authToken)
    if authToken ~= TempAuthToken then return end
    if ClientHealthBuffer.bodyParts[bodyPart].tourniquetApplied then return end

    ClientHealthBuffer.bodyParts[bodyPart].tourniquetApplied = true
    ClientHealthBuffer.bodyParts[bodyPart].tourniquetAppliedTime = GetGameTimer()
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_REMOVE_TOURNIQUET, function(bodyPart, authToken)
    if not ClientHealthBuffer.bodyParts[bodyPart].tourniquetApplied then return end
    ClientHealthBuffer.bodyParts[bodyPart].tourniquetApplied = false
    ClientHealthBuffer.bodyParts[bodyPart].tourniquetAppliedTime = 0

    for k, v in ipairs(ClientHealthBuffer.bodyParts[bodyPart].blocked_medications) do
        table.remove(ClientHealthBuffer.bodyParts[bodyPart].blocked_medications, k)
        AddMedicationLocal(bodyPart, v)
    end

    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_INJECT_MEDICATION, function(bodyPart, medication, authToken)
    if authToken ~= TempAuthToken then return end
    if medication == "morphine" or medication == "epinephrine" then SpawnGameObject("visn_injector_" .. medication, ClientData.coords.x, ClientData.coords.y, ClientData.coords.z - 0.95) end
    AddMedicationLocal(bodyPart, medication)
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_BANDAGE, function(bodyPart, bandageType, authToken)
    if authToken ~= TempAuthToken then return end
    local targetWound, effectiveness = FindMostEffectiveWound(ClientHealthBuffer, bandageType, bodyPart)

    if effectiveness == -1 or not targetWound then -- No wounds on this body part
        SpawnGameObject("visn_bandage", ClientData.coords.x, ClientData.coords.y, ClientData.coords.z - 0.95)
        return
    end

    local woundIndex, finalWound = FindInjuryInHealthBuffer(ClientHealthBuffer, bodyPart, targetWound.id)
    if woundIndex == -1 or not finalWound then return end

    local amount = GetInjuryLevelAsNumber(finalWound.level)
    local impact = math.min(effectiveness, amount)
    local woundWillOpenAgain = false

    amount = amount - impact
    finalWound.level = GetInjuryLevelFromNumber(amount)
    SpawnGameObject("visn_bandage_blood", ClientData.coords.x, ClientData.coords.y, ClientData.coords.z - 0.95)

    if amount <= 0 or finalWound.level == "none" and not woundWillOpenAgain then

        if ClientConfig.m_enableSewings then
            woundWillOpenAgain = HandleBandageOpening(bodyPart, targetWound.key, bandageType, targetWound.id)
        end

        if not woundWillOpenAgain then
            ClientHealthBuffer.bodyParts[bodyPart].injuries[targetWound.key] = nil
            ClientHealthBuffer.bodyParts[bodyPart].injuryAmount = math.max(0, ClientHealthBuffer.bodyParts[bodyPart].injuryAmount - 1)
            if bodyPart == "LEFT_LEG" or bodyPart == "RIGHT_LEG" then ResetPedMovementClipset(ClientData.ped, 0.0) end
        end
    end

    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_SURGICAL_KIT, function(bodyPart, authToken)
    if authToken ~= TempAuthToken then return end
    for k, v in pairs(ClientHealthBuffer.bodyParts[bodyPart].injuries) do
        if v.needSewing then
            ClientHealthBuffer.bodyParts[bodyPart].injuries[k] = nil
            ClientHealthBuffer.bodyParts[bodyPart].injuryAmount = math.max(0, ClientHealthBuffer.bodyParts[bodyPart].injuryAmount - 1)
        end
    end

    SpawnGameObject("visn_gloves", ClientData.coords.x, ClientData.coords.y, ClientData.coords.z - 0.95)
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_INFUSION, function(bodyPart, infusion, volume, authToken)
    if authToken ~= TempAuthToken then return end

    for i, v in ipairs(ClientHealthBuffer.infusions) do
        if v.bodyPart == bodyPart and v.name == infusion then
            ClientHealthBuffer.infusions[i].remainingVolume = ClientHealthBuffer.infusions[i].remainingVolume + volume
            ClientHealthBuffer.infusions[i].totalVolume = ClientHealthBuffer.infusions[i].totalVolume + volume
            ReportHealthBufferUpdate()
            LogDebug(TableContains(ClientConfig.m_debugModeModules, "infusions"), "Infusion (" .. infusion .. "; " .. volume .. "ml) updated at " .. bodyPart .. ".")
            return
        end
    end

    table.insert(ClientHealthBuffer.infusions, {
        name = infusion,
        remainingVolume = volume,
        totalVolume = volume,
        bodyPart = bodyPart
    })

    LogDebug(TableContains(ClientConfig.m_debugModeModules, "infusions"), "Infusion (" .. infusion .. "; " .. volume .. "ml) applied at " .. bodyPart .. ".")
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_CPR, function(bodyPart, authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer.unconscious then return end

    if not ClientHealthBuffer.non_recovery_mode then
        if math.random(0, 100) >= 50 then
            ClientHealthBuffer.heartRate = ClientHealthBuffer.heartRate + math.random(3, 30)
        end
    end

    ClientHealthBuffer.unconsciousTimeUntilDeath = ClientHealthBuffer.unconsciousTimeUntilDeath + 150
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_DEFIBRILLATOR, function(bodyPart, authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer.unconscious then return end
    if math.random(0, 100) > 50 then return end
    if ClientHealthBuffer.non_recovery_mode then return end

    ClientHealthBuffer.heartRate = ClientHealthBuffer.heartRate + math.random(0, 55)
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_APPLY_EMERGENCY_REVIVE_KIT, function(bodyPart, authToken)
    if authToken ~= TempAuthToken then return end

    SpawnGameObject("visn_gloves", ClientData.coords.x, ClientData.coords.y, ClientData.coords.z - 0.95)
    ResetHealthBuffer()
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_RESPAWN_PLAYER, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end

    local nearestLocation, nearestDistance = nil, 9000000
    for _, v in pairs(ClientConfig.m_respawnConfiguration.m_respawnLocations) do
        local distance = #(ClientData.coords - vector3(v.x, v.y, v.z))
        if distance < nearestDistance then
            nearestLocation = v
            nearestDistance = distance
        end
    end

    RespawnPed(ClientData.ped, { x = nearestLocation.x, y = nearestLocation.y, z = nearestLocation.z }, nearestLocation.hospital)
    RemoveAllPedWeapons(ClientData.ped, true)

    SetUnconsciousState(false)
    ResetHealthBuffer()

    if CarryAnimationData ~= nil then
        ClearPedTasks(ClientData.ped)
        DetachEntity(ClientData.ped, true, false)
        CarryAnimationData = nil
    end
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_SAVE_LOG, function(logs, authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end

    ClientHealthBuffer.logs = logs
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_PUT_IN_VEHICLE, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end
    if not ClientHealthBuffer.unconscious and not ClientHealthBuffer.anesthesia then return end

    local vehicle, distance = GetCustomClosestVehicle(ClientData.coords)
    if distance > ClientConfig.m_vehicleScanRadius then return end
    if not IsEntityAVehicle(vehicle) then return end
    local maxPassengers = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = -1

    local startIndex = 0
    if maxPassengers >= 3 then startIndex = 1 end

    for i = startIndex, (maxPassengers - 1) - startIndex do
        if IsVehicleSeatFree(vehicle, i) then
            freeSeat = i
            break
        end
    end

    if freeSeat then
        TaskWarpPedIntoVehicle(ClientData.ped, vehicle, freeSeat)
    end
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_PUT_IN_BODYBAG, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end
    if not ClientHealthBuffer.unconscious and not ClientHealthBuffer.anesthesia then return end

    SetEntityAlpha(PlayerPedId(), 0, false)
    SetEntityVisible(PlayerPedId(), false, false)

    RequestModel(GetHashKey("xm_prop_body_bag"))
    while not HasModelLoaded(GetHashKey("xm_prop_body_bag")) do
        Citizen.Wait(0)
    end

    local bodyBag = CreateObject(GetHashKey("xm_prop_body_bag"), ClientData.coords.x, ClientData.coords.y, ClientData.coords.z, true, true, false)
    AttachEntityToEntity(bodyBag, ClientData.ped, 0, -0.2, 0.75, -0.2, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
    BodyBagObject = bodyBag

    ClientHealthBuffer.bodybag = true
    ClientHealthBuffer.unconsciousTimeUntilDeath = math.min(ClientHealthBuffer.unconsciousTimeUntilDeath, ClientConfig.m_bodybagUnconsciousTime)
    ClientHealthBuffer.activeECG = false

    SendNUIMessage({
        payload = "showManualRespawnText",
        payloadData = {
            value = true,
            key = ClientConfig.m_configurableKeys.m_useInputMapper
            and GetControlStringFromKeyMapping("manual_respawn")
            or GetControlStringFromKeyMappingNoInputMapper(ClientConfig.m_configurableKeys.keys.MANUAL_RESPAWN.control_id)
        }
    })
    AllowManualRespawn = true

    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_START_ECG, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end

    ClientHealthBuffer.activeECG = true
    ReportHealthBufferUpdate()
end)
RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_STOP_ECG, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end

    ClientHealthBuffer.activeECG = false
    ReportHealthBufferUpdate()
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_PULL_OUT_VEHICLE, function(authToken)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end
    if not ClientHealthBuffer.unconscious and not ClientHealthBuffer.anesthesia then return end
    if not IsPedSittingInAnyVehicle(ClientData.ped) then return end

    local vehicle = GetVehiclePedIsIn(ClientData.ped, false)
    TaskLeaveVehicle(ClientData.ped, vehicle, 16)
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_SYNC_LOCAL, function(authToken, animationData)
    if authToken ~= TempAuthToken then return end
    RequestAnimDict(animationData.lib)
    while not HasAnimDictLoaded(animationData.lib) do Citizen.Wait(0) end

    TaskPlayAnim(ClientData.ped, animationData.lib, animationData.name, 8.0, -8.0, animationData.length, animationData.flag, 0, false, false, false)
    CarryAnimationData = {
        lib = animationData.lib,
        name = animationData.name,
        flag = animationData.flag
    }
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_SYNC_TARGET, function(authToken, targetSource, animationData)
    if authToken ~= TempAuthToken then return end
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSource))
    if not targetPed or targetPed == -1 then return end

    RequestAnimDict(animationData.lib)
    while not HasAnimDictLoaded(animationData.lib) do Citizen.Wait(0) end
    if animationData.zRotation == nil then animationData.zRotation = 180.0 end
    if animationData.flag == nil then animationData.flag = 0 end

    AttachEntityToEntity(ClientData.ped, targetPed, 0, animationData.xDistance, animationData.yDistance, animationData.zDistance, 0.5, 0.5, animationData.zRotation, false, false, false, false, 2, false)
    TaskPlayAnim(ClientData.ped, animationData.lib, animationData.name, 8.0, -8.0, animationData.length, animationData.flag, 0, false, false, false)
    CarryAnimationData = {
        lib = animationData.lib,
        name = animationData.name,
        flag = animationData.flag
    }
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_STOP_CARRY, function(authToken)
    if authToken ~= TempAuthToken then return end

    ClearPedTasks(ClientData.ped)
    DetachEntity(ClientData.ped, true, false)
    CarryAnimationData = nil
end)

RegisterNetEvent(ENUM_EVENT_TYPES.EVENT_SET_HEALTH_BUFFER, function(authToken, healthBuffer)
    if authToken ~= TempAuthToken then return end

    for k, v in pairs(healthBuffer) do
        if k ~= "unconscious" then
            ClientHealthBuffer[k] = v
        end
    end

    if healthBuffer.unconscious == true then
        SetUnconsciousState(true)
    end
end)

RegisterNetEvent(ENUM_EVENT_TYPES.PROCEDURE_UPDATE_TRIAGE, function(authToken, triageSelection)
    if authToken ~= TempAuthToken then return end
    if not ClientHealthBuffer then return end

    if triageSelection == "black" then
        if not ClientHealthBuffer.unconscious then return end
    end

    SendNUIMessage({
        payload = "showManualRespawnText",
        payloadData = {
            value = ClientConfig.m_configurableKeys.keys.MANUAL_RESPAWN.enabled and triageSelection == "black",
            key = ClientConfig.m_configurableKeys.m_useInputMapper
            and GetControlStringFromKeyMapping("manual_respawn")
            or GetControlStringFromKeyMappingNoInputMapper(ClientConfig.m_configurableKeys.keys.MANUAL_RESPAWN.control_id)
        }
    })

    AllowManualRespawn = triageSelection == "black"
    ClientHealthBuffer.triageSelection = triageSelection
    ReportHealthBufferUpdate()
end)

RegisterNetEvent("visn_are:resetHealthBuffer", function()
    ResetHealthBuffer()
end)