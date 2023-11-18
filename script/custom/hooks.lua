HookEventHandler(ENUM_HOOKABLE_EVENTS.PLAYER_RESPAWNED, function()
    ResetThirstHungerStatus()
end)

HookEventHandler(ENUM_HOOKABLE_EVENTS.UNCONSCIOUS_STATE_CHANGED, function(newState)
end)

HookEventHandler(ENUM_HOOKABLE_EVENTS.DAMAGE_RECEIVED, function(damageType, damageAmount, bodyPart)
end)

function ResetThirstHungerStatus()
    TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 25)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 25)
    TriggerServerEvent("QBCore:Server:SetMetaData", "stress", 0)
end