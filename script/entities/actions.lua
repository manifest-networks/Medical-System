--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

local _defaultAnimationData = { lib = "anim@heists@narcotics@funding@gang_idle", name = "gang_chatting_idle01" }

AVAILABLE_ACTIONS = {
    ["diagnoses"] = {
        {
            name = "CHECK_CONSCIOUSNESS",
            exclusiveBodyParts = { "HEAD" },
            cooldown = 3000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            log = function(bodyPart, result)
                
                if result then
                    result = TranslateText("LOG_PATIENT_CONSCIOUS")
                else
                    result = TranslateText("LOG_PATIENT_UNCONSCIOUS")
                end

                return TranslateText("LOG_CONSCIOUSNESS_CHECKED", TranslateText(bodyPart), result)
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                if not healthBuffer.unconscious and not healthBuffer.anesthesia then
                    ShowNotification(TranslateText("PATIENT_IS_ALIVE"))
                    callback(true)
                    return
                end

                ShowNotification(TranslateText("PATIENT_NOT_ALIVE"))
                callback(false)
            end
        },

        {
            name = "CHECK_PULSE",
            cooldown = 12000,
            animation = _defaultAnimationData,
            log = function(bodyPart, result)
                return TranslateText("LOG_PULSE_MEASURED", TranslateText(bodyPart), result)
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                local heartRate = RoundValue(GetHeartRate(healthBuffer, bodyPart))
                ShowNotification(TranslateText("PULSE_MEASURED", heartRate))
                callback(heartRate)
            end
        },

        {
            name = "CHECK_BLOOD_PRESSURE",
            cooldown = 12000,
            animation = _defaultAnimationData,
            log = function(bodyPart, result)
                return TranslateText("LOG_BLOOD_PRESSURE_MEASURED", TranslateText(bodyPart), result[1], result[2])
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                local pressureH, pressureL = GetBloodPressure(healthBuffer, bodyPart)
                ShowNotification(TranslateText("BLOOD_PRESSURE_MEASURED", pressureH, pressureL))
                callback({ pressureH, pressureL })
            end
        }
    },

    ["bandages"] = {
        {
            name = "APPLY_TOURNIQUET",
            exclusiveBodyParts = { "LEFT_ARM", "RIGHT_ARM", "LEFT_LEG", "RIGHT_LEG" },
            cooldown = 3000,
            requiredItem = {
                name = "tourniquet",
                count = 1
            },
            animation = _defaultAnimationData,
            log = function(bodyPart, result)
                return TranslateText("LOG_TOURNIQUET_APPLIED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodyParts[bodyPart].tourniquetApplied and not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                if healthBuffer.bodyParts[bodyPart].tourniquetApplied then return end
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_TOURNIQUET, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        },
        {
            name = "REMOVE_TOURNIQUET",
            exclusiveBodyParts = { "LEFT_ARM", "RIGHT_ARM", "LEFT_LEG", "RIGHT_LEG" },
            cooldown = 3000,
            animation = _defaultAnimationData,
            log = function(bodyPart, result)
                return TranslateText("LOG_TOURNIQUET_REMOVED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return healthBuffer.bodyParts[bodyPart].tourniquetApplied and not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                if not healthBuffer.bodyParts[bodyPart].tourniquetApplied then return end
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_REMOVE_TOURNIQUET, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        },
        {
            name = "APPLY_SURGICAL_KIT",
            cooldown = 30000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            requiredItem = {
                name = "surgical_kit",
                count = 1
            },
            log = function(bodyPart, result)
                return TranslateText("LOG_SURGICAL_KIT_APPLIED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return IsSewNeeded(healthBuffer, bodyPart) and not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_SURGICAL_KIT, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        }
    },

    ["cpr"] = {
        {
            name = "APPLY_CPR",
            cooldown = 30000,
            animation = {
                lib = "mini@cpr@char_a@cpr_str",
                name = "cpr_pumpchest"
            },
            hideOnSelf = true,
            log = function(bodyPart, result)
                return TranslateText("LOG_CPR_APPLIED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) and not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_CPR, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        },

        {
            name = "APPLY_DEFIBRILLATOR",
            cooldown = 9000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            sound = {
                name = "defibrillator",
                distance = 8
            },
            requiredItem = {
                name = "defibrillator",
                count = 1
            },
            log = function(bodyPart, result)
                return TranslateText("LOG_DEFIBIRLATOR_APPLIED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) and not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_DEFIBRILLATOR, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        },

        {
            name = "APPLY_EMERGENCY_REVIVE_KIT",
            cooldown = 30000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            requiredItem = {
                name = "emergency_revive_kit",
                count = 1
            },
            log = function(bodyPart, result)
                return TranslateText("LOG_EMERGENCY_REVIVE_KIT_APPLIED", TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_EMERGENCY_REVIVE_KIT, TempAuthToken, clientData.source, bodyPart)
                callback(true)
            end
        },

        {
            name = "START_ECG",
            cooldown = 10000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            exclusiveBodyParts = { "TORSO" },
            requiredItem = {
                name = "ecg_monitor",
                count = 1,
            },
            condition = function(healthBuffer, bodyPart) return not healthBuffer.activeECG end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_START_ECG, TempAuthToken, clientData.source)
                callback(true)
            end
        },

        {
            name = "STOP_ECG",
            cooldown = 5000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            exclusiveBodyParts = { "TORSO" },
            condition = function(healthBuffer, bodyPart) return healthBuffer.activeECG end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_STOP_ECG, TempAuthToken, clientData.source)
                callback(true)
            end
        }
    },

    ["carry"] = {
        {
            name = "CARRY",
            cooldown = 4000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                if ClientConfig.m_disableDefaultUnconsciousAnimation then 
                    LogWarning("Carry is currently not available with m_disableDefaultUnconsciousAnimation enabled.")
                    return
                end

                CarryPlayer(clientData, healthBuffer)
                callback(true)
            end
        },
        {
            name = "PUT_IN_VEHICLE",
            cooldown = 3000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_PUT_IN_VEHICLE, TempAuthToken, clientData.source)
                callback(true)
            end
        },
        {
            name = "PULL_OUT_VEHICLE",
            cooldown = 3000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_PULL_OUT_VEHICLE, TempAuthToken, clientData.source)
                callback(true)
            end
        },
        {
            name = "PUT_IN_BODYBAG",
            cooldown = 12000,
            animation = _defaultAnimationData,
            hideOnSelf = true,
            condition = function(healthBuffer, bodyPart) return (healthBuffer.unconscious or healthBuffer.anesthesia) and not healthBuffer.bodybag end,
            log = function(bodyPart, result)
                return TranslateText("LOG_PUT_IN_BODYBAG", TranslateText(bodyPart))
            end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_PUT_IN_BODYBAG, TempAuthToken, clientData.source)
                callback(true)
            end
        },
    },

    ["syringes"] = {}, -- Don't touch
    ["infusions"] = {} -- Don't touch
}

function GetAvailableActionsLocal(isSelf, category, bodyPart, healthBuffer)
    if not AVAILABLE_ACTIONS[category] then LogWarning("Tried to index ", category, " in available actions but category wasn't found.") return {} end

    local finalList = {}

    local items = PlayerItems
    for k, v in pairs(items) do
        if type(v) == "number" then
            if v > 0 then items[k] = v end
        elseif type(v) == "table" then
            if v.count > 0 then items[v.name] = v.count end
        end
    end

    for _, v in pairs(AVAILABLE_ACTIONS[category]) do
        local hasItem = not v.requiredItem or (v.requiredItem and items[v.requiredItem.name])
        local notHidden = not v.hideOnSelf or (v.hideOnSelf and not isSelf)
        local includedBodyPart = not v.exclusiveBodyParts or v.exclusiveBodyParts and TableContains(v.exclusiveBodyParts, bodyPart)
        local condition = not v.condition or (v.condition and v.condition(healthBuffer, bodyPart))
        
        if not ClientConfig.m_onlyShowActionsIfPlayerHasRequiredItems then
            if notHidden and includedBodyPart and condition then
                table.insert(finalList, v.name)
            end
        else
            if hasItem and notHidden and includedBodyPart and condition then
                table.insert(finalList, v.name)
            end
        end
    end

    return finalList
end

function LoadActionsFromEntities()
    for k, v in PairsByKeys(BANDAGES) do
        table.insert(AVAILABLE_ACTIONS["bandages"],{
            name = "APPLY_" .. string.upper(k),
            cooldown = v.cooldown * 1000,
            animation = _defaultAnimationData,
            requiredJobs = v.requiredJobs or nil,
            requiredItem = {
                name = k,
                count = 1
            },
            log = function(bodyPart, result)
                return TranslateText("LOG_BANDAGE_APPLIED", TranslateText(string.upper(k)), TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_BANDAGE, TempAuthToken, clientData.source, bodyPart, k)
                callback(true)
            end
        })
    end

    for k, v in PairsByKeys(INFUSIONS) do
        for _, volume in pairs(v.availableVolumes) do
            table.insert(AVAILABLE_ACTIONS["infusions"],{
                name = "APPLY_" .. string.upper(k) .. "_" .. volume,
                cooldown = v.cooldown * 1000,
                animation = _defaultAnimationData,
                requiredJobs = v.requiredJobs or nil,
                requiredItem = {
                    name = k .. "_" .. volume,
                    count = 1
                },
                log = function(bodyPart, result)
                    return TranslateText("LOG_INFUSION_APPLIED", TranslateText(string.upper(k)), volume, TranslateText(bodyPart))
                end,
                condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
                action = function(clientData, healthBuffer, bodyPart, callback)
                    TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_APPLY_INFUSION, TempAuthToken, clientData.source, bodyPart, k, volume)
                    callback(true)
                end
            })
        end
    end

    for k, v in PairsByKeys(MEDICATIONS) do
        table.insert(AVAILABLE_ACTIONS["syringes"],{
            name = "INJECT_" .. string.upper(k),
            exclusiveBodyParts = { "LEFT_ARM", "RIGHT_ARM", "LEFT_LEG", "RIGHT_LEG" },
            cooldown = 5000,
            animation = _defaultAnimationData,
            requiredJobs = v.requiredJobs or nil,
            requiredItem = {
                name = k,
                count = 1
            },
            log = function(bodyPart, result)
                return TranslateText("LOG_MEDICATION_INJECTED", TranslateText(string.upper(k)), TranslateText(bodyPart))
            end,
            condition = function(healthBuffer, bodyPart) return not healthBuffer.bodybag end,
            action = function(clientData, healthBuffer, bodyPart, callback)
                TriggerServerEvent(ENUM_EVENT_TYPES.EVENT_INJECT_MEDICATION, TempAuthToken, clientData.source, bodyPart, k)
                callback(true)
            end
        })
    end
end