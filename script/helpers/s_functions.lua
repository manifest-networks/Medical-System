--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

--- Server extension module for Advanced Roleplay Environment.

---Returns true if the player has the item with the specified amount
---@param source any
---@param item any
---@param amount any
---@return boolean
function HasItem(source, item, amount)
    source = tonumber(source)
    if not ServerConfig.m_itemsNeeded or ShouldIgnoreItems(source) then return true end
    if not amount then amount = 1 end

    LogDebug(TableContains(ServerConfig.m_debugModeModules, "items"), "HasItem on player ", GetPlayerName(source),
        " and item", item)

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then return false end

        if not ServerConfig.m_customInventory.enabled then -- Default inventory handling
            return frameworkPlayer.getInventoryItem(item) and frameworkPlayer.getInventoryItem(item).count >= amount
        end

        if ServerConfig.m_customInventory.inventory_type == "ox_inventory" then
            return exports.ox_inventory:Search(source, 'count', item) >= amount
        elseif ServerConfig.m_customInventory.inventory_type == "qs-inventory" then
            return frameworkPlayer.getInventoryItem(item) and frameworkPlayer.getInventoryItem(item).count >= amount
        elseif ServerConfig.m_customInventory.inventory_type == "mf-inventory" then
            return frameworkPlayer.getInventoryItem(item) and frameworkPlayer.getInventoryItem(item).count >= amount
        elseif ServerConfig.m_customInventory.inventory_type == "core_inventory" then
            local inventory = 'content-' .. frameworkPlayer.identifier:gsub(":", "")
            return exports["core_inventory"]:getItem(inventory, item) and exports["core_inventory"]:getItem(inventory, item).count >= amount
        end

    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then return false end
        return frameworkPlayer.Functions.GetItemByName(item).amount >= amount
    end

    -- Implement your own logic (standalone)
    return true
end

---Adds an item to the player
---@param source any
---@param item any
---@param amount any
---@return boolean
function AddItem(source, item, amount)
    source = tonumber(source)
    if not amount then amount = 1 end
    LogDebug(TableContains(ServerConfig.m_debugModeModules, "items"), "AddItem on player ", GetPlayerName(source),
        " and item", item)

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then return false end


        if not ServerConfig.m_customInventory.enabled then -- Default inventory handling
            if frameworkPlayer.canCarryItem(item, amount) then
                frameworkPlayer.addInventoryItem(item, amount)
                return true
            end

            return false
        end

        if ServerConfig.m_customInventory.inventory_type == "ox_inventory" then
            if exports.ox_inventory:CanCarryItem(source, item, amount) then
                exports.ox_inventory:AddItem(source, item, amount)
                return true
            end

        elseif ServerConfig.m_customInventory.inventory_type == "qs-inventory" then
            if frameworkPlayer.canCarryItem(item, amount) then
                frameworkPlayer.addInventoryItem(item, amount)
                return true
            end

        elseif ServerConfig.m_customInventory.inventory_type == "mf-inventory" then
            if frameworkPlayer.canCarryItem(item, amount) then
                frameworkPlayer.addInventoryItem(item, amount)
                return true
            end
        elseif ServerConfig.m_customInventory.inventory_type == "core_inventory" then
            return exports["core_inventory"]:addItem('content-' ..  frameworkPlayer.identifier:gsub(":", ""), item, amount, nil)
        end

        return false
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then return false end
        return frameworkPlayer.Functions.AddItem(item, amount)
    end

    return true
    -- Implement your own logic (standalone)
end

---Removes an item from the player
---@param source any
---@param item any
---@param amount any
function RemoveItem(source, item, amount)
    source = tonumber(source)
    if not amount then amount = 1 end
    LogDebug(TableContains(ServerConfig.m_debugModeModules, "items"), "RemoveItem on player ", GetPlayerName(source),
        " and item", item)

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then return end

        if not ServerConfig.m_customInventory.enabled then -- Default inventory handling
            if HasItem(source, item, amount) then
                frameworkPlayer.removeInventoryItem(item, amount)
            end

            return
        end

        if ServerConfig.m_customInventory.inventory_type == "ox_inventory" then
            exports.ox_inventory:RemoveItem(source, item, amount)
        elseif ServerConfig.m_customInventory.inventory_type == "qs-inventory" then
            frameworkPlayer.removeInventoryItem(item, amount)
        elseif ServerConfig.m_customInventory.inventory_type == "mf-inventory" then
            frameworkPlayer.removeInventoryItem(item, amount)
        elseif ServerConfig.m_customInventory.inventory_type == "core_inventory" then
            exports["core_inventory"]:removeItem('content-' ..  frameworkPlayer.identifier:gsub(":", ""), item, amount)
        end

    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then return end
        frameworkPlayer.Functions.RemoveItem(item, amount)
    end

    -- Implement your own logic (standalone)
end

---Gets all items from the player
---@param source any
---@return table
function GetItems(source)
    source = tonumber(source)
    if not ServerConfig.m_itemsNeeded or ShouldIgnoreItems(source) then return GetAvailableItems() end

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then return {} end

        local items = frameworkPlayer.getInventory(true)
        if ServerConfig.m_customInventory.enabled and ServerConfig.m_customInventory.inventory_type == "core_inventory" then
            items = exports["core_inventory"]:getInventory('content-' ..  frameworkPlayer.identifier:gsub(":", ""))
        end

        for _, v in pairs(items) do
            if type(v) == "table" and v.count > 0 then
                items[v.name] = v.count
            end
        end

        return items
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then return {} end

        local items = {}
        for _, v in pairs(frameworkPlayer.PlayerData.items) do
            items[v.name] = v.amount
        end

        return items
    end

    -- Implement your own logic (standalone)
    return {}
end

---Returns true if the player is allowed to perform a action
---@param source any
---@param category any
---@param action any
---@return boolean
function IsAllowedToPerformAction(source, category, action)
    source = tonumber(source)
    if not AVAILABLE_ACTIONS[category] then return false end
    local actionData = nil
    for _, v in pairs(AVAILABLE_ACTIONS[category]) do
        if v.name == action then
            actionData = v
            break
        end
    end

    if not actionData then return false end
    if not actionData.requiredJobs then return true end

    return TableContains(actionData.requiredJobs, GetPlayerJob(source))
end

---Returns true if the player is allowed to open the menu
---@param source any
---@return boolean
function IsAllowedToOpenMenu(source)
    source = tonumber(source)
    if not ServerConfig.m_limitMenuToJobs.enabled then return true end

    local playerJob = GetPlayerJob(source)
    if not playerJob then return false end

    return TableContains(ServerConfig.m_limitMenuToJobs.jobs, playerJob)
end

---Saves the player
---@param source any
function SavePlayer(source)
    source = tonumber(source)
    if not ServerConfig.m_stateSaving.enabled then return end
    if not ValidateSource(source) then return end

    local healthBuffer = Player(source).state.healthBuffer
    if not healthBuffer then return end

    -- Remove logs and clientside properties
    healthBuffer.logs = nil
    healthBuffer.lastHeartRateChange = nil
    healthBuffer.lastDamageTimestamp = nil
    healthBuffer.lastReceivedPain = nil
    healthBuffer.triageSelection = nil
    healthBuffer.lastDamage = nil
    healthBuffer._lastHealth = nil
    healthBuffer.lastHandledDamageTimestamp = nil
    healthBuffer.unconscious_timestamp = nil
    healthBuffer.unconsciousTimeUntilDeath = nil

    local playerIdentifier = GetPlayerCustomIdentifier(source)
    if not playerIdentifier then return end

    if ServerConfig.m_stateSaving.method == 'oxmysql' then
        local databaseConfig = ServerConfig.m_stateSaving.database
        exports["oxmysql"]:update("UPDATE " .. databaseConfig.table .. " SET " .. databaseConfig.column .. " = ? WHERE " .. databaseConfig.identifierColumn .. " = ?", { json.encode(healthBuffer), playerIdentifier })
    elseif ServerConfig.m_stateSaving.method == 'mysql-async' then
        local databaseConfig = ServerConfig.m_stateSaving.database
        exports["mysql-async"]:mysql_execute("UPDATE " .. databaseConfig.table .. " SET " .. databaseConfig.column .. " = @value WHERE " .. databaseConfig.identifierColumn .. " = @identifier", {
            ['value'] = json.encode(healthBuffer),
            ['identifier'] = playerIdentifier
        })
    elseif ServerConfig.m_stateSaving.method == 'file' then
        local filePath = ServerConfig.m_stateSaving.file.path
        local fileEnding
        local encodedData

        if ServerConfig.m_stateSaving.file.type == 'message_pack' then
            encodedData = msgpack.pack(healthBuffer)
            fileEnding = ".bin"
        elseif ServerConfig.m_stateSaving.file.type == 'json' then
            encodedData = json.encode(healthBuffer)
            fileEnding = ".json"
        else
            LogError("Invalid file type for state saving")
            return
        end

        if not fileEnding or not encodedData then return end
        local fileName = (filePath .. playerIdentifier .. fileEnding):gsub("%:", "_")
        
        local file, err = io.open(GetResourcePath(GetCurrentResourceName()) .. fileName,'wb')
        
        if err then
            LogError("Player state saving (" .. playerIdentifier .. ") failed: " .. err)
            return
        end

        if file then
            file:write(encodedData)
            file:close()
        end
    else
        LogWarning("Unknown state saving method: " .. ServerConfig.m_stateSaving.method)
        return
    end
end

---Loads the player
---@param source any
function LoadPlayer(source)
    source = tonumber(source)
    if not ServerConfig.m_stateSaving.enabled then return end
    if not ValidateSource(source) then return end

    local playerIdentifier = GetPlayerCustomIdentifier(source) or "invalid_identifier"
    if not playerIdentifier then return end

    if ServerConfig.m_stateSaving.method == 'oxmysql' then
        local databaseConfig = ServerConfig.m_stateSaving.database
        exports["oxmysql"]:query("SELECT " .. databaseConfig.column .. " FROM " .. databaseConfig.table .. " WHERE " .. databaseConfig.identifierColumn .. " = ?", { playerIdentifier }, function(result)
            if not result or not result[1] or not result[1][databaseConfig.column] then return end

            local healthBuffer = json.decode(result[1][databaseConfig.column])
            if not healthBuffer then return end
            LogDebug(true, "Loaded health buffer for " .. playerIdentifier .. " (sql) | unconscious-state: ", healthBuffer.unconscious)

            healthBuffer.unconscious = healthBuffer.unconscious == true
            healthBuffer.medications = {}

            Player(source).state:set("healthBuffer", healthBuffer, true)
            TriggerClientEvent(ENUM_EVENT_TYPES.EVENT_SET_HEALTH_BUFFER, source, AuthToken, healthBuffer)
        end)
    elseif ServerConfig.m_stateSaving.method == 'mysql-async' then
        local databaseConfig = ServerConfig.m_stateSaving.database
        exports["mysql-async"]:mysql_fetch_all("SELECT " .. databaseConfig.column .. " FROM " .. databaseConfig.table .. " WHERE " .. databaseConfig.identifierColumn .. "=@identifier", { ['identifier'] = playerIdentifier }, function(result)
            if not result or not result[1] or not result[1][databaseConfig.column] then return end

            local healthBuffer = json.decode(result[1][databaseConfig.column])
            if not healthBuffer then return end
            LogDebug(true, "Loaded health buffer for " .. playerIdentifier .. " (sql) | unconscious-state: ", healthBuffer.unconscious)
            healthBuffer.unconscious = healthBuffer.unconscious == true
            healthBuffer.medications = {}

            Player(source).state:set("healthBuffer", healthBuffer, true)
            TriggerClientEvent(ENUM_EVENT_TYPES.EVENT_SET_HEALTH_BUFFER, source, AuthToken, healthBuffer)
        end)
    elseif ServerConfig.m_stateSaving.method == 'file' then
        local filePath = ServerConfig.m_stateSaving.file.path
        local healthBuffer
        local fileName = (filePath .. playerIdentifier):gsub("%:", "_")

        if ServerConfig.m_stateSaving.file.type == 'message_pack' then
            local data = LoadResourceFile(GetCurrentResourceName(), fileName .. ".bin")
            if not data then return end

            healthBuffer = msgpack.unpack(data)
        elseif ServerConfig.m_stateSaving.file.type == 'json' then
            local data = LoadResourceFile(GetCurrentResourceName(), fileName .. ".json")
            if not data then return end
            healthBuffer = json.decode(data)
        else
            LogError("Invalid file type for state saving")
            return
        end

        if not healthBuffer then return end
        LogDebug(true, "Loaded health buffer for " .. playerIdentifier .. " (" .. fileName .. ") | unconscious-state: ", healthBuffer.unconscious or false)
        healthBuffer.unconscious = (healthBuffer.unconscious or false) == true
        healthBuffer.medications = {}

        Player(source).state:set("healthBuffer", healthBuffer, true)
        TriggerClientEvent(ENUM_EVENT_TYPES.EVENT_SET_HEALTH_BUFFER, source, AuthToken, healthBuffer)
    else
        LogWarning("Unknown state saving method: " .. ServerConfig.m_stateSaving.method)
        return
    end
end

---Gets the menu title name from the player
---@param source any
---@return unknown
function GetPlayerMenuTitleName(source)
    source = tonumber(source)
    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        return FRAMEWORK_DATA.GetPlayerFromId(source).getName()
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        return FRAMEWORK_DATA.Functions.GetPlayer(source).PlayerData.charinfo.firstname ..
            ' ' .. FRAMEWORK_DATA.Functions.GetPlayer(source).PlayerData.charinfo.lastname
    end

    -- Implement your own logic (standalone)
    return GetPlayerName(source)
end

---Gets the player job
---@param source any
---@return unknown
function GetPlayerJob(source)
    source = tonumber(source)
    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then LogWarning("Tried to get player job but player doesnt have a framework player?",
            source) return "" end
        return frameworkPlayer.getJob().name
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then LogWarning("Tried to get player job but player doesnt have a framework player?",
            source) return "" end
        return frameworkPlayer.PlayerData.job.name
    end

    -- Implement your own logic (standalone)
    return ""
end

---Gets the player identifier (framework related)
---@param source any
---@return any
function GetPlayerCustomIdentifier(source)
    source = tonumber(source)
    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then LogWarning("Tried to get player identifier but player doesnt have a framework player?"
            , source) return end
        return frameworkPlayer.getIdentifier()
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        local frameworkPlayer = FRAMEWORK_DATA.Functions.GetPlayer(source)
        if not frameworkPlayer then LogWarning("Tried to get player identifier but player doesnt have a framework player?"
            , source) return end
        return frameworkPlayer.PlayerData.citizenid
    end

    return GetRealIdentifier(source)
end

---Returns true if the player should return item amounts
---@param source any
---@return boolean
function ShouldIgnoreItems(source)
    source = tonumber(source)
    if not ServerConfig.m_itemsNeeded then return true end
    return TableContains(ServerConfig.m_ignoreItemsNeededJobs, GetPlayerJob(source))
end

---Gets the medics on duty
---@return integer
function GetMedicsOnDutyCount()
    local medicsOnDuty = 0

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local xPlayers = ESX.GetExtendedPlayers()

        for _, v in pairs(xPlayers) do
            if TableContains(ServerConfig.m_dependUnconsciousTimeOnMedicCount.jobs, v.job.name) then
                medicsOnDuty = medicsOnDuty + 1
            end
        end
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        for _, player in pairs(FRAMEWORK_DATA.Functions.GetPlayers()) do
            local Player = FRAMEWORK_DATA.Functions.GetPlayer(player)
            if TableContains(ServerConfig.m_dependUnconsciousTimeOnMedicCount.jobs, Player.PlayerData.job.name) then
                medicsOnDuty = medicsOnDuty + 1
            end
        end
    else
        -- Implement your own logic (standalone)
    end

    return medicsOnDuty
end

---Returns true if the player is allowed to use the triage system
---@param source any
---@return boolean
function IsAllowedToUseTriageSystem(source)
    source = tonumber(source)
    if not ServerConfig.m_triageSystem.enabled then return false end
    if not ServerConfig.m_triageSystem.jobRestriction then return true end

    local job = GetPlayerJob(source)
    return TableContains(ServerConfig.m_triageSystem.jobs, job)
end

---Returns true if the player is allowed to use the revive command
---@param source any
function IsAllowedToUseReviveCommand(source)
    source = tonumber(source)
    if not ServerConfig.m_reviveCommand then return false end

    if FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.ES_EXTENDED then
        local frameworkPlayer = FRAMEWORK_DATA.GetPlayerFromId(source)
        if not frameworkPlayer then return false end
        return frameworkPlayer.getGroup() == "admin" or frameworkPlayer.getGroup() == "superadmin"
    elseif FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE then
        return FRAMEWORK_DATA.Functions.HasPermission(source, 'admin')
    end

    -- Your own logic (standalone)
    return IsPlayerAceAllowed(source, "command.revive")
end

---Gets all available items configured in the actions.lua
---@return table
function GetAvailableItems()
    local items = {}
    for _, v in pairs(AVAILABLE_ACTIONS) do
        for _, v2 in pairs(v) do
            if v2.requiredItem then items[v2.requiredItem.name] = v2.requiredItem end
        end
    end
    return items
end

---Sends a discord log to the discord api
---@param message any
---@param description any
function SendDiscordLog(message, description)
    if not ServerConfig.m_discordLogging.enabled then return end
    if not ServerConfig.m_discordLogging.webhook or ServerConfig.m_discordLogging.webhook == "" then return end
    if not message or message == "" then return end

    local discordEmbed = {
        ["title"] = message,
        ["description"] = description or "",
        ["type"] = "rich",
        ["color"] = "16754688",
        ["footer"] = {
            ["text"] = "Advanced Roleplay Environment (" .. CURRENT_BUILD .. ")",
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }

	PerformHttpRequest(ServerConfig.m_discordLogging.webhook, function(err, text, headers) end, 'POST', json.encode({ "Advanced Roleplay Environment", embeds = { discordEmbed }}), { ['Content-Type'] = 'application/json' })
end
