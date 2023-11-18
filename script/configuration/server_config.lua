--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

ServerConfig = {
    -- [[ General Settings    ]] --
    m_itemsNeeded = true, -- Set this 'true', if you want that players need items to perform actions.
    m_reviveCommand = false, -- Set this 'true', if you want to enable the integrated revive command. For permissions see s_functions.lua (IsAllowedToUseReviveCommand)

    -- [[ Custom ESX Settings ]] --
    m_esxSharedObject = {
        useExport = false, -- Set this 'true', if you want to use the ESX Shared Object instead of the old event
        resourceName = "es_extended", -- Set the resource name of the ESX (needed for export)
        eventName = "esx:getSharedObject", -- Event name of the ESX Shared Object.
    },

    -- [[ Custom QBCore Settings ]] --
    m_qbCoreResourceName = "qb-core", -- Set the resource name of the QBCore (needed for export)

    m_customInventory = { -- If you use a custom inventory
        enabled = false,
        inventory_type = "qs-inventory", -- supported: ox_inventory , qs-inventory, mf-inventory, core_inventory
    },

    -- [[ Feature Settings    ]] --
    m_ignoreItemsNeededJobs = { "ambulance" }, -- A table of jobs that ignore the that players need items to perform actions.

    m_dependUnconsciousTimeOnMedicCount = {
        enabled = true, -- Set this to 'true', if you want that the system will depend on the medic count.
        jobs = { "ambulance" }, -- A table of jobs that will count to the final count of medics.
        overwrites = { -- Keep in order: Lowest to highest!
            -- Format: [Medic count as number] = Time in seconds
            [0] = 60 * 5, -- 5 Minutes when medicCount >= 0
            [2] = ClientConfig.m_respawnConfiguration.m_respawnTime, -- Default time when medicCount >= 2
        }
    },

    m_limitMenuToJobs = { -- Limits the menu to certain jobs.
        enabled = false, -- Set this 'true', if you want that the system will limit the menu to certain jobs.
        jobs = { "ambulance" }, -- A table of jobs that are allowed to use the menu.
    },

    m_triageSystem = {
        enabled = false, -- Set this 'true', if you want that the triage system is enabled.
        jobRestriction = true, -- Set this 'true', if you want that the triage system is restricted to certain jobs.
        jobs = { "ambulance" }, -- A table of jobs that are allowed to use the triage system.
    },

    m_stateSaving = { -- This feature will save the state of the players (like injuries, blood pressure) to a file (recommend) or mysql database.
        enabled = true, -- Set this to 'true', if you want that the system will save the state of the players.
        interval = 60 * 5, -- Set this to the interval in seconds, that the system will save the state of the players.
        method = 'oxmysql', -- 'oxmysql', 'mysql-async' or 'file' (recommended)
        database = { -- Set this to the database settings, if you use oxmysql.
            table = 'players', -- Set this to the table name, where the state will be saved.
            column = 'health_state', -- The column in the table, that will be used to save the state of the players.
            identifierColumn = 'citizenid' -- The column in the table, that will be used to query the player.
        },
        file = { -- Set this to the file settings, if you use file.
            path = '/database/', -- Set this to the path of the file, where the system will save the state of the players.
            type = 'message_pack', -- The type of serialization. message_pack (recommended) or json
        }
    },

    m_discordLogging = { -- This feature will log kill logs to discord.
        enabled = false,  -- Set this to 'true', if you want that the system will log messages to Discord.
        healthBuffer = true, -- Set this to 'true', if you want that the system will also log the healthBuffer on a kill.
        webhook = '' -- Set this to the webhook URL of your discord channel.s
    },

    -- [[ Menu Settings    ]] --
    m_showNameOfPlayerOnMenuTitle = true, -- Set this to 'true', if you want that the system will show the name of the player on the menu title. Set this to 'false', if you want that the system will not show the name of the player on the menu title.

    -- [[ Respawn Settings ]] -- 
    m_respawnConfiguration = {
        m_removeMoneyOnDeath = false, -- Set this to 'true', if you want that players lose money on death.
        m_removeItemsOnDeath = false, -- Set this to 'true', if you want that players lose items on death.
        m_removeWeaponsOnDeath = false, -- Set this to 'true', if you want that players lose weapons on death.
    },

    -- [[ Debug Settings      ]] --
    m_debugModeEnabled = false, -- Set this to 'true', if you want expanded informations about things that are going on.
    m_debugModeModules = { "items" },
}

Citizen.CreateThread(function()
    while not (FRAMEWORK == ENUM_DEFINED_FRAMEWORKS.QB_CORE) do
        Wait(1000)
    end

    Wait(1000)
    FRAMEWORK_DATA.Functions.AddItems({
        ['field_dressing'] = {
            name = 'field_dressing',
            label = 'Field Dressing',
            weight = 100,
            type = 'item',
            image = 'field_dressing.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'A field dressing is a kind of bandage intended to be carried by soldiers for immediate use in case of (typically gunshot) wounds.'
        },
        ['packing_bandage'] = {
            name = 'packing_bandage',
            label = 'Packing Bandage',
            weight = 100,
            type = 'item',
            image = 'packing_bandage.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'A packing bandage is a kind of bandage intended to packup wounds (typically gunshot).'
        },
        ['elastic_bandage'] = {
            name = 'elastic_bandage',
            label = 'Elastic bandage',
            weight = 100,
            type = 'item',
            image = 'elastic_bandage.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Elastic bandages are used to provide the high compression needed for the management of gross varices, post-thrombotic venous insufficiency, venous leg ulcers, and gross oedema in average-sized limbs.'
        },
        ['quickclot'] = {
            name = 'quickclot',
            label = 'Quickclot',
            weight = 100,
            type = 'item',
            image = 'quickclot.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'QuikClot is a brand of hemostatic wound dressing, that contains an agent that promotes blood clotting. It is primarily used by militaries and law enforcement to treat hemorrhaging from trauma.'
        },
        ['blood_100'] = {
            name = 'blood_100',
            label = 'Blood Bag (100ml)',
            weight = 100,
            type = 'item',
            image = 'blood_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Blood bags are used for the reliable collection, separation, storage and transport of blood.'
        },
        ['blood_250'] = {
            name = 'blood_250',
            label = 'Blood Bag (250ml)',
            weight = 250,
            type = 'item',
            image = 'blood_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Blood bags are used for the reliable collection, separation, storage and transport of blood.'
        },
        ['blood_500'] = {
            name = 'blood_500',
            label = 'Blood Bag (500ml)',
            weight = 500,
            type = 'item',
            image = 'blood_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Blood bags are used for the reliable collection, separation, storage and transport of blood.'
        },
        ['blood_750'] = {
            name = 'blood_750',
            label = 'Blood Bag (750ml)',
            weight = 750,
            type = 'item',
            image = 'blood_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Blood bags are used for the reliable collection, separation, storage and transport of blood.'
        },
        ['blood_1000'] = {
            name = 'blood_1000',
            label = 'Blood Bag (1L)',
            weight = 1000,
            type = 'item',
            image = 'blood_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Blood bags are used for the reliable collection, separation, storage and transport of blood.'
        },
        ['morphine'] = {
            name = 'morphine',
            label = 'Morphine',
            weight = 10,
            type = 'item',
            image = 'morphine.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Each ml of solution for injection contains 10 mg Morphine Sulfate.'
        },
        ['epinephrine'] = {
            name = 'epinephrine',
            label = 'Epinephrine',
            weight = 10,
            type = 'item',
            image = 'epinephrine.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'EpiPen auto injectors are automatic injection devices containing adrenaline for allergic emergencies.'
        },
        ['emergency_revive_kit'] = {
            name = 'emergency_revive_kit',
            label = 'ERK',
            weight = 1500,
            type = 'item',
            image = 'emergency_revive_kit.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Hmm.. I wonder what this thing does?'
        },
        ['defibrillator'] = {
            name = 'defibrillator',
            label = 'Defibrillator',
            weight = 3000,
            type = 'item',
            image = 'defibrillator.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Defibrillation is a treatment for life-threatening cardiac arrhythmias, specifically ventricular fibrillation and non-perfusing ventricular tachycardia.'
        },
        ['surgical_kit'] = {
            name = 'surgical_kit',
            label = 'Surgical Kit',
            weight = 500,
            type = 'item',
            image = 'surgical_kit.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Used to stitch up wounds.'
        },
        ['tourniquet'] = {
            name = 'tourniquet',
            label = 'Tourniquet',
            weight = 20,
            type = 'item',
            image = 'tourniquet.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'A tourniquet\'s primary purpose is to stop life-threatening external bleeding'
        },
        ['ecg_monitor'] = {
            name = 'ecg_monitor',
            label = 'ECG',
            weight = 2500,
            type = 'item',
            image = 'ecg_monitor.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'An electrocardiogram (ECG) is a simple test that can be used to check your heart\'s rhythm and electrical activity'
        },
        ['fentanyl'] = {
            name = 'fentanyl',
            label = 'Fentanyl',
            weight = 2,
            type = 'item',
            image = 'fentanyl.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Fentanyl is a strong opioid painkiller. It\'s used to treat severe pain, for example during or after an operation or a serious injury, or pain from cancer.'
        },
        ['propofol_100'] = {
            name = 'propofol_100',
            label = 'Propofol (100ml)',
            weight = 100,
            type = 'item',
            image = 'propofol_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Propofol is a short-acting medication that results in a decreased level of consciousness and a lack of memory for events.'
        },
        ['propofol_250'] = {
            name = 'propofol_250',
            label = 'Propofol (250ml)',
            weight = 250,
            type = 'item',
            image = 'propofol_100.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Propofol is a short-acting medication that results in a decreased level of consciousness and a lack of memory for events.'
        },
        ['bodybag'] = {
            name = 'bodybag',
            label = 'Bodybag',
            weight = 250,
            type = 'item',
            image = 'bodybag.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'A heavy-duty plastic bag used to transport a deceased person.'
        },
        ['painkiller_100'] = {
            name = 'painkiller_100',
            label = 'Painkiller 100mg',
            weight = 100,
            type = 'item',
            image = 'painkillers.png',
            unique = false,
            useable = true,
            shouldClose = true,
            combinable = nil,
            description = 'Painkillers are a medicine used to treat mild to moderate pain.'
        }
    })
end)