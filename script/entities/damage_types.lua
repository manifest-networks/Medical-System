--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

DAMAGE_TYPES = {
    ["bullet"] = {
        thresholds = { { damage = 1, amount = 1 }, { damage = 1, amount = 3 }, { damage = 1, amount = 4 } },
        selectionSpecific = true,
    },

    ["explosion"] = {
        thresholds = { { damage = 1, amount = 3 }, { damage = 40, amount = 4 }, { damage = 100, amount = 6 } },
        selectionSpecific = false,
    },

    ["vehicle_crash"] = {
        thresholds = { { damage = 1, amount = 1 }, { damage = 100, amount = 2 }, { damage = 150, amount = 3 } },
        selectionSpecific = false,
    },

    ["collision"] = {
        thresholds = { { damage = 1, amount = 1 }, { damage = 40, amount = 2 }, { damage = 70, amount = 3 } },
        selectionSpecific = false,
    },

    ["stab"] = {
        thresholds = { { damage = 1, amount = 1 } },
        selectionSpecific = true,
    },

    ["punch"] = {
        thresholds = { { damage = 1, amount = 1 } },
        selectionSpecific = true,
    },

    ["falling"] = {
        thresholds = { { damage = 5, amount = 1 }, { damage = 100, amount = 2 }, { damage = 150, amount = 2 } },
        selectionSpecific = false,
    },

    ["burn"] = {
        thresholds = { { damage = 1, amount = 1 } },
        selectionSpecific = true,
    },

    ["drowned"] = {
        thresholds = { { damage = 1, amount = 1 } },
        selectionSpecific = true,
    },

    ["unknown"] = {
        thresholds = { { damage = 1, amount = 1 } },
        selectionSpecific = false,
    }
}

for k, v in pairs(DAMAGE_TYPES) do v.key = k end

ENUM_DAMAGE_HASHES = {
    -- Melee

    -- TYPE = { hash = HASH, category = CATERGORY }

    WEAPON_UNARMED = { hash = -1569615261, category = DAMAGE_TYPES["punch"] },
    WEAPON_KNIFE = { hash = -1716189206, category = DAMAGE_TYPES["stab"] },
    WEAPON_NIGHTSTICK = { hash = 1737195953, category = DAMAGE_TYPES["punch"] },
    WEAPON_HAMMER = { hash = 1317494643, category = DAMAGE_TYPES["punch"] },
    WEAPON_BAT = { hash = -1786099057, category = DAMAGE_TYPES["punch"] },
    WEAPON_CROWBAR = { hash = -2067956739, category = DAMAGE_TYPES["punch"] },
    WEAPON_GOLFCLUB = { hash = 1141786504, category = DAMAGE_TYPES["punch"] },
    WEAPON_BOTTLE = { hash = -102323637, category = DAMAGE_TYPES["stab"] },
    WEAPON_DAGGER = { hash = -1834847097, category = DAMAGE_TYPES["stab"] },
    WEAPON_HATCHET = { hash = -102973651, category = DAMAGE_TYPES["stab"] },
    WEAPON_KNUCKLE = { hash = -656458692, category = DAMAGE_TYPES["punch"] },
    WEAPON_MACHETE = { hash = -581044007, category = DAMAGE_TYPES["stab"] },
    WEAPON_FLASHLIGHT = { hash = -1951375401, category = DAMAGE_TYPES["punch"] },
    WEAPON_SWITCHBLADE = { hash = -538741184, category = DAMAGE_TYPES["stab"] },
    WEAPON_POOLCUE = { hash = -1810795771, category = DAMAGE_TYPES["punch"] },
    WEAPON_WRENCH = { hash = 419712736, category = DAMAGE_TYPES["punch"] },
    WEAPON_BATTLEAXE = { hash = -853065399, category = DAMAGE_TYPES["stab"] },
    WEAPON_STONE_HATCHET = { hash = 940833800, category = DAMAGE_TYPES["stab"] },
    -- Melee [ADDON]
    WEAPON_SHIV = { hash = `weapon_shiv`, category = DAMAGE_TYPES["stab"] },
    WEAPON_KATANA = { hash = `weapon_katana`, category = DAMAGE_TYPES["stab"] },
    WEAPON_SLEDGEHAMMER = { hash = `weapon_sledgehammer`, category = DAMAGE_TYPES["punch"] },
    WEAPON_KARAMBIT = { hash = `weapon_karambit`, category = DAMAGE_TYPES["stab"] },
    WEAPON_COLBATON = { hash = `weapon_colbaton`, category = DAMAGE_TYPES["punch"] },
    WEAPON_LUCILLE = { hash = `weapon_lucille`, category = DAMAGE_TYPES["punch"] },
    WEAPON_BREAD = { hash = `weapon_bread`, category = DAMAGE_TYPES["punch"] },

    -- Handguns    
    WEAPON_PISTOL = { hash = 453432689, category = DAMAGE_TYPES["bullet"] },
    WEAPON_PISTOL_MK2 = { hash = -1075685676, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMBATPISTOL = { hash = 1593441988, category = DAMAGE_TYPES["bullet"] },
    WEAPON_APPISTOL = { hash = 584646201, category = DAMAGE_TYPES["bullet"] },
    --WEAPON_STUNGUN = { hash = 911657153, category = DAMAGE_TYPES["bullet"] },
    WEAPON_PISTOL50 = { hash = -1716589765, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SNSPISTOL = { hash = -1076751822, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SNSPISTOL_MK2 = { hash = -2009644972, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HEAVYPISTOL = { hash = -771403250, category = DAMAGE_TYPES["bullet"] },
    WEAPON_VINTAGEPISTOL = { hash = 137902532, category = DAMAGE_TYPES["bullet"] },
    WEAPON_FLAREGUN = { hash = 1198879012, category = DAMAGE_TYPES["burn"] },
    WEAPON_MARKSMANPISTOL = { hash = -598887786, category = DAMAGE_TYPES["bullet"] },
    WEAPON_REVOLVER = { hash = -1045183535, category = DAMAGE_TYPES["bullet"] },
    WEAPON_REVOLVER_MK2 = { hash = -879347409, category = DAMAGE_TYPES["bullet"] },
    WEAPON_DOUBLEACTION = { hash = -1746263880, category = DAMAGE_TYPES["bullet"] },
    WEAPON_CERAMICPISTOL = { hash = 727643628, category = DAMAGE_TYPES["bullet"] },
    WEAPON_NAVYREVOLVER = { hash = -1853920116, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GADGETPISTOL = { hash = 1470379660, category = DAMAGE_TYPES["bullet"] },
    -- Handguns [ADDON]
    WEAPON_DP9 = { hash = `weapon_dp9`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GLOCK = { hash = `weapon_glock`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_DE = { hash = `weapon_de`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_FNX45 = { hash = `weapon_fnx45`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GLOCK17 = { hash = `weapon_glock17`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_M9 = { hash = `weapon_m9`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_M1911 = { hash = `weapon_m1911`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GLOCK18C = { hash = `weapon_glock18c`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GLOCK22 = { hash = `weapon_glock22`, category = DAMAGE_TYPES["bullet"] },

    -- Submachine Guns
    WEAPON_MICROSMG = { hash = 324215364, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SMG = { hash = 736523883, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SMG_MK2 = { hash = 2024373456, category = DAMAGE_TYPES["bullet"] },
    WEAPON_ASSAULTSMG = { hash = -270015777, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMBATPDW = { hash = 171789620, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MACHINEPISTOL = { hash = -619010992, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MINISMG = { hash = -1121678507, category = DAMAGE_TYPES["bullet"] },
    -- Submachine Guns [ADDON]
    WEAPON_UZI = { hash = `weapon_uzi`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MAC10 = { hash = `weapon_mac10`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MP9 = { hash = `weapon_mp9`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MP5 = { hash = `weapon_mp5`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GEPARD = { hash = `weapon_gepard`, category = DAMAGE_TYPES["bullet"] },

    -- Shotguns
    WEAPON_PUMPSHOTGUN = { hash = 487013001, category = DAMAGE_TYPES["bullet"] },
    WEAPON_PUMPSHOTGUN_MK2 = { hash = 1432025498, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SAWNOFFSHOTGUN = { hash = 2017895192, category = DAMAGE_TYPES["bullet"] },
    WEAPON_ASSAULTSHOTGUN = { hash = -494615257, category = DAMAGE_TYPES["bullet"] },
    WEAPON_BULLPUPSHOTGUN = { hash = -1654528753, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MUSKET = { hash = -1466123874, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HEAVYSHOTGUN = { hash = 984333226, category = DAMAGE_TYPES["bullet"] },
    WEAPON_DBSHOTGUN = { hash = -275439685, category = DAMAGE_TYPES["bullet"] },
    WEAPON_AUTOSHOTGUN = { hash = 317205821, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMBATSHOTGUN = { hash = 94989220, category = DAMAGE_TYPES["bullet"] },
    -- Shotgun [ADDON]
    WEAPON_LTL = { hash = `weapon_ltl`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MOSSBERG = { hash = `weapon_mossberg`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_REMINGTON = { hash = `weapon_remington`, category = DAMAGE_TYPES["bullet"] },

    -- Assault Rifles
    WEAPON_ASSAULTRIFLE = { hash = -1074790547, category = DAMAGE_TYPES["bullet"] },
    WEAPON_ASSAULTRIFLE_MK2 = { hash = 961495388, category = DAMAGE_TYPES["bullet"] },
    WEAPON_CARBINERIFLE = { hash = -2084633992, category = DAMAGE_TYPES["bullet"] },
    WEAPON_CARBINERIFLE_MK2 = { hash = -86904375, category = DAMAGE_TYPES["bullet"] },
    WEAPON_ADVANCEDRIFLE = { hash = -1357824103, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SPECIALCARBINE = { hash = -1063057011, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SPECIALCARBINE_MK2 = { hash = -1768145561, category = DAMAGE_TYPES["bullet"] },
    WEAPON_BULLPUPRIFLE = { hash = 2132975508, category = DAMAGE_TYPES["bullet"] },
    WEAPON_BULLPUPRIFLE_MK2 = { hash = -2066285827, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMPACTIRIFLE = { hash = 1649403952, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MILITARYRIFLE = { hash = -1658906650, category = DAMAGE_TYPES["bullet"] },
    -- Assault Rifles [ADDON]
    WEAPON_M14 = { hash = `weapon_m14`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_M4 = { hash = `weapon_m4`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_AK47 = { hash = `weapon_ak47`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_M70 = { hash = `weapon_m70`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_SCARH = { hash = `weapon_scarh`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_AR15 = { hash = `weapon_ar15`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HK416 = { hash = `weapon_hk416`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_AK74 = { hash = `weapon_ak74`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_AKS74 = { hash = `weapon_aks74`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_LBRS = { hash = `weapon_lbrs`, category = DAMAGE_TYPES["bullet"] },
    
    -- Light Machine Guns
    WEAPON_MG = { hash = -1660422300, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMBATMG = { hash = 2144741730, category = DAMAGE_TYPES["bullet"] },
    WEAPON_COMBATMG_MK2 = { hash = -608341376, category = DAMAGE_TYPES["bullet"] },
    WEAPON_GUSENBERG = { hash = 1627465347, category = DAMAGE_TYPES["bullet"] },
    -- Light Machine Guns [ADDON]

    -- Sniper Rifles
    WEAPON_SNIPERRIFLE = { hash = 100416529, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HEAVYSNIPER = { hash = 205991906, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HEAVYSNIPER_MK2 = { hash = 177293209, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MARKSMANRIFLE = { hash = -952879014, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MARKSMANRIFLE_MK2 = { hash = 1785463520, category = DAMAGE_TYPES["bullet"] },
    -- Sniper Rifles [ADDON]
    WEAPON_LR25 = { hash = `weapon_lr25`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_MK14 = { hash = `weapon_mk14`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_HUNTINGRIFLE = { hash = `weapon_huntingrifle`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_M110 = { hash = `weapon_m110`, category = DAMAGE_TYPES["bullet"] },
    WEAPON_DRAGUNOV = { hash = `weapon_dragunov`, category = DAMAGE_TYPES["bullet"] },

    -- Heavy Weapons
    WEAPON_RPG = { hash = -1312131151, category = DAMAGE_TYPES["explosion"] },
    WEAPON_GRENADELAUNCHER = { hash = -1568386805, category = DAMAGE_TYPES["explosion"] },
    WEAPON_MINIGUN = { hash = 1119849093, category = DAMAGE_TYPES["bullet"] },
    WEAPON_FIREWORK = { hash = 2138347493, category = DAMAGE_TYPES["explosion"] },
    WEAPON_HOMINGLAUNCHER = { hash = 1672152130, category = DAMAGE_TYPES["explosion"] },
    WEAPON_COMPACTLAUNCHER = { hash = 125959754, category = DAMAGE_TYPES["explosion"] },
    -- Heavy Weapons [ADDON]

    -- Throwables
    WEAPON_GRENADE = { hash = -1813897027, category = DAMAGE_TYPES["explosion"] },
    WEAPON_BZGAS = { hash = -1600701090, category = DAMAGE_TYPES["unknown"] },
    WEAPON_MOLOTOV = { hash = 615608432, category = DAMAGE_TYPES["burn"] },
    WEAPON_STICKYBOMB = { hash = 741814745, category = DAMAGE_TYPES["explosion"] },
    WEAPON_PROXMINE = { hash = -1420407917, category = DAMAGE_TYPES["explosion"] },
    WEAPON_SNOWBALL = { hash = 126349499, category = DAMAGE_TYPES["unknown"] },
    WEAPON_PIPEBOMB = { hash = -1169823560, category = DAMAGE_TYPES["explosion"] },
    WEAPON_SMOKEGRENADE = { hash = -37975472, category = DAMAGE_TYPES["unknown"] },
    -- Throwables [ADDON]
    WEAPON_BOOK = { hash = `weapon_book`, category = DAMAGE_TYPES["unknown"] },
    WEAPON_BRICK = { hash = `weapon_brick`, category = DAMAGE_TYPES["punch"] },
    WEAPON_CASH = { hash = `weapon_cash`, category = DAMAGE_TYPES["unknown"] },
    WEAPON_SHOE = { hash = `weapon_shoe`, category = DAMAGE_TYPES["punch"] },
    WEAPON_FLASHBANG = { hash = `weapon_flashbang`, category = DAMAGE_TYPES["unknown"] },

    -- Miscellaneous
    WEAPON_PETROLCAN = { hash = -544306709, category = DAMAGE_TYPES["burn"] },
    WEAPON_NAILGUN = { hash = `weapon_nailgun`, category = DAMAGE_TYPES["bullet"] },
    -- Miscellaneous [ADDON]

    -- Explosion Types
    WEAPON_HELICOPTERCRASH = { hash = -1945616459, category = DAMAGE_TYPES["explosion"] },

    -- GTA-Damage Types
    WEAPON_CAR_CRASH = { hash = 133987706, category = DAMAGE_TYPES["vehicle_crash"] },
    WEAPON_DROWNED = { hash = -10959621, category = DAMAGE_TYPES["drowned"] },
    WEAPON_DROWNED_IN_CAR = { hash = 1936677264, category = DAMAGE_TYPES["drowned"] },
    WEAPON_EXPLOSION = { hash = 539292904, category = DAMAGE_TYPES["explosion"] },
    WEAPON_HIT_BY_WATER_CANNON = { hash = -868994466, category = DAMAGE_TYPES["collision"] },
    WEAPON_HELI_BLADES = { hash = -1323279794, category = DAMAGE_TYPES["stab"] },
    WEAPON_RAMMED_BY_CAR = { hash = -1553120962, category = DAMAGE_TYPES["collision"] },
    WEAPON_FALL = { hash = -842959696, category = DAMAGE_TYPES["falling"] },

    -- ADDON WEAPONS (https://wiki.rage.mp/index.php?title=Weapons)
}

ENUM_COMPARE_DAMAGE_TYPES = {}
for _, v in pairs(ENUM_DAMAGE_HASHES) do ENUM_COMPARE_DAMAGE_TYPES[v.hash] = v.category end