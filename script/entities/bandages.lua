--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

BANDAGES = {
    ["field_dressing"] = {
        effectiveness = 1,
        cooldown = 5,
        reopeningChance = 0.1,
        reopeningMinDelay = 120,
        reopeningMaxDelay = 200,

        ["abrasion"] = {
            effectiveness = 3,
            reopeningChance = 0.3,
            reopeningMinDelay = 200,
            reopeningMaxDelay = 1000,
        },

        ["avulsion"] = {
            effectiveness = 1,
            reopeningChance = 0.5,
            reopeningMinDelay = 120,
            reopeningMaxDelay = 200
        },

        ["contusion"] = {
            effectiveness = 1,
            reopeningChance = 0,
            reopeningMinDelay = 0,
            reopeningMaxDelay = 0
        },

        ["crush"] = {
            effectiveness = 1,
            reopeningChance = 0.2,
            reopeningMinDelay = 200,
            reopeningMaxDelay = 1000
        },

        ["cut"] = {
            effectiveness = 4,
            reopeningChance = 0.1,
            reopeningMinDelay = 300,
            reopeningMaxDelay = 1000
        },

        ["laceration"] = {
            effectiveness = 0.95,
            reopeningChance = 0.3,
            reopeningMinDelay = 100,
            reopeningMaxDelay = 800
        },

        ["velocity_wound"] = {
            effectiveness = 0.2,
            reopeningChance = 0.7,
            reopeningMinDelay = 100,
            reopeningMaxDelay = 500
        },

        ["puncture_wound"] = {
            effectiveness = 0.2,
            reopeningChance = 0.5,
            reopeningMinDelay = 200,
            reopeningMaxDelay = 850
        }
    },

    ["packing_bandage"] = {
        effectiveness = 1,
        cooldown = 4,
        reopeningChance = 0.1,
        reopeningMinDelay = 120,
        reopeningMaxDelay = 200,

        ["abrasion"] = {
            effectiveness = 3,
            reopeningChance = 0.6,
            reopeningMinDelay = 800,
            reopeningMaxDelay = 1500,
        },

        ["avulsion"] = {
            effectiveness = 1,
            reopeningChance = 0.7,
            reopeningMinDelay = 1000,
            reopeningMaxDelay = 1600
        },

        ["contusion"] = {
            effectiveness = 1,
            reopeningChance = 0,
            reopeningMinDelay = 0,
            reopeningMaxDelay = 0
        },

        ["crush"] = {
            effectiveness = 1,
            reopeningChance = 0.5,
            reopeningMinDelay = 600,
            reopeningMaxDelay = 1000
        },

        ["cut"] = {
            effectiveness = 4,
            reopeningChance = 0.4,
            reopeningMinDelay = 700,
            reopeningMaxDelay = 1000
        },

        ["laceration"] = {
            effectiveness = 0.95,
            reopeningChance = 0.65,
            reopeningMinDelay = 500,
            reopeningMaxDelay = 2000
        },

        ["velocity_wound"] = {
            effectiveness = 2,
            reopeningChance = 1,
            reopeningMinDelay = 800,
            reopeningMaxDelay = 2000
        },

        ["puncture_wound"] = {
            effectiveness = 2,
            reopeningChance = 1,
            reopeningMinDelay = 1000,
            reopeningMaxDelay = 3000
        }
    },
    
    ["elastic_bandage"] = {
        effectiveness = 1,
        cooldown = 4,
        reopeningChance = 0.1,
        reopeningMinDelay = 120,
        reopeningMaxDelay = 200,

        ["abrasion"] = {
            effectiveness = 4,
            reopeningChance = 0.6,
            reopeningMinDelay = 80,
            reopeningMaxDelay = 150,
        },

        ["avulsion"] = {
            effectiveness = 2,
            reopeningChance = 0.7,
            reopeningMinDelay = 100,
            reopeningMaxDelay = 160
        },

        ["contusion"] = {
            effectiveness = 2,
            reopeningChance = 0,
            reopeningMinDelay = 0,
            reopeningMaxDelay = 0
        },

        ["crush"] = {
            effectiveness = 2,
            reopeningChance = 0.5,
            reopeningMinDelay = 60,
            reopeningMaxDelay = 100
        },

        ["cut"] = {
            effectiveness = 5,
            reopeningChance = 0.4,
            reopeningMinDelay = 70,
            reopeningMaxDelay = 100
        },

        ["laceration"] = {
            effectiveness = 2,
            reopeningChance = 0.65,
            reopeningMinDelay = 50,
            reopeningMaxDelay = 200
        },

        ["velocity_wound"] = {
            effectiveness = 2.2,
            reopeningChance = 1,
            reopeningMinDelay = 80,
            reopeningMaxDelay = 200
        },

        ["puncture_wound"] = {
            effectiveness = 2.5,
            reopeningChance = 1,
            reopeningMinDelay = 100,
            reopeningMaxDelay = 300
        }
    },
    
    ["quickclot"] = {
        effectiveness = 1,
        cooldown = 3,
        reopeningChance = 0.1,
        reopeningMinDelay = 120,
        reopeningMaxDelay = 200,

        ["abrasion"] = {
            effectiveness = 2,
            reopeningChance = 0.3,
            reopeningMinDelay = 800,
            reopeningMaxDelay = 1500,
        },

        ["avulsion"] = {
            effectiveness = 0.7,
            reopeningChance = 0.2,
            reopeningMinDelay = 1000,
            reopeningMaxDelay = 1600
        },

        ["contusion"] = {
            effectiveness = 1,
            reopeningChance = 0,
            reopeningMinDelay = 0,
            reopeningMaxDelay = 0
        },

        ["crush"] = {
            effectiveness = 0.6,
            reopeningChance = 0.5,
            reopeningMinDelay = 600,
            reopeningMaxDelay = 1000
        },

        ["cut"] = {
            effectiveness = 2,
            reopeningChance = 0.2,
            reopeningMinDelay = 700,
            reopeningMaxDelay = 1000
        },

        ["laceration"] = {
            effectiveness = 0.7,
            reopeningChance = 0.4,
            reopeningMinDelay = 500,
            reopeningMaxDelay = 2000
        },

        ["velocity_wound"] = {
            effectiveness = 1,
            reopeningChance = 0.5,
            reopeningMinDelay = 800,
            reopeningMaxDelay = 2000
        },

        ["puncture_wound"] = {
            effectiveness = 1,
            reopeningChance = 0.5,
            reopeningMinDelay = 1000,
            reopeningMaxDelay = 3000
        }
    }
}