--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

INJURIES = {
    -- Available options:
    
    -- causes: table: Table of the damage types that causes this injury
    -- bleeding: number: How much this injury will affect the bleeding
    -- pain: number: How much this injury will affect the pain
    -- causeLimping: bool: If this injury will cause limping when active
    -- causeFracture: bool: If this injury will cause a fracture (not implemented yet)
    -- needSeewing: bool: If this injury could cause a need for seewing
    -- exclusiveBodyParts: table: Table of body parts that this injury can only be applied to
    
    -- Also called scrapes, they occur when the skin is rubbed away by friction against another rough surface (e.g. rope burns and skinned knees).
    ["abrasion"] = {
        causes = { "falling", "vehicle_crash", "collision" },
        bleeding = 0.001,
        minDamage = 4,
        maxDamage = 75,
        pain = 0.4
    },

    -- Occur when an entire structure or part of it is forcibly pulled away, such as the loss of a permanent tooth or an ear lobe. Explosions, gunshots, and animal bites may cause avulsions.
    ["avulsion"] = {
        causes = { "explosion", "bullet" },
        bleeding = 0.1,
        pain = 0.1,
        minDamage = 1,
        causeLimping = true,
        needSewing = true,
        causeWeaponAimShake = true
    },

    -- Also called bruises, these are the result of a forceful trauma that injures an internal structure without breaking the skin. Blows to the chest, abdomen, or head with a blunt instrument (e.g. a football or a fist) can cause contusions.
    ["contusion"] = {
        causes = { "punch", "vehicle_crash", "falling", "collision" },
        bleeding = 0,
        timeout = 200,
        minDamage = 2,
        maxDamage = 25,
        pain = 0.3
    },

    -- Occur when a heavy object falls onto a person, splitting the skin and shattering or tearing underlying structures.
    ["crush"] = {
        causes = { "punch", "vehicle_crash", "falling", "collision" },
        bleeding = 0.05,
        pain = 0.8,
        minDamage = 50,
        causeLimping = true,
        needSewing = true,
        causeFracture = true
    },

    -- Slicing wounds made with a sharp instrument, leaving even edges. They may be as minimal as a paper cut or as significant as a surgical incision.
    ["cut"] = {
        causes = { "stab", "vehicle_crash", "explosion" },
        bleeding = 0.01,
        minDamage = 10,
        needSewing = true,
        pain = 0.1
    },

    -- Also called tears, these are separating wounds that produce ragged edges. They are produced by a tremendous force against the body, either from an internal source as in childbirth, or from an external source like a punch.
    ["laceration"] = {
        causes = { "vehicle_crash", "stab" },
        bleeding = 0.05,
        minDamage = 2,
        needSewing = true,
        pain = 0.2
    },

    -- Also called velocity wounds, they are caused by an object entering the body at a high speed, typically a bullet or small peices of shrapnel.
    ["velocity_wound"] = {
        causes = { "explosion", "bullet" },
        bleeding = 0.2,
        pain = 0.1,
        minDamage = 1,
        causeLimping = true,
        causeFracture = true,
        needSewing = true,
        causeWeaponAimShake = true
    },

    ["burn_injury"] = {
        causes = { "burn" },
        bleeding = 0.01,
        pain = 0.2,
    },

    -- Deep, narrow wounds produced by sharp objects such as nails, knives, and broken glass.
    ["puncture_wound"] = {
        causes = { "stab", "explosion" },
        bleeding = 0.05,
        pain = 0.4,
        minDamage = 2,
        needSewing = true,
        causeLimping = true
    }
}