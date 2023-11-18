--[[
-- Author: Tim Plate
-- Project: Advanced Roleplay Environment
-- Copyright (c) 2022 Tim Plate Solutions
--]]

MEDICATIONS = {
    -- Available options: --
       
    -- painReduce: number: How much does the pain get reduced?
    -- hrIncreaseLow: table: How much will the heart rate be increased when the HR is low (below 55)? {minIncrease, maxIncrease}
    -- hrIncreaseNormal: 55 <= _heartRate <= 110
    -- hrIncreaseHigh: 110 > _heartRate

    -- timeInSystem: number: How long until this medication has disappeared
    -- timeTillMaxEffect: number: How long until the maximum effect is reached
    -- maxDose: number: How many of this type of medication can be in the system before the patient overdoses?
    -- onOverDose: number: Function to execute upon overdose. -1 for no overdose.
    -- causesAnesthesia: bool: If this medication causes anesthesia
    -- viscosityChange: number: The viscosity of a fluid is a measure of its resistance to gradual deformation by shear stress or tensile stress. For liquids, it corresponds to the informal concept of "thickness". This value will increase/decrease the viscoty of the blood with the percentage given. Where 100 = max. Using the minus will decrease viscosity.

    ["morphine"] = {
        painReduce        = 0.8,
        hrIncreaseLow     = { -20, -10 },
        hrIncreaseNormal  = { -30, -10 },
        hrIncreaseHigh    = { -35, -10 },
        timeInSystem      = 1800,
        timeTillMaxEffect = 30,
        maxDose           = 4,
        viscosityChange   = -10
    },

    ["epinephrine"] = {
        painReduce        = 0.0,
        hrIncreaseLow     = { 10, 20 },
        hrIncreaseNormal  = { 10, 50 },
        hrIncreaseHigh    = { 10, 40 },
        timeInSystem      = 120,
        timeTillMaxEffect = 10,
        maxDose           = 10,
        viscosityChange   = 0
    },

    ["fentanyl"] = {
        painReduce        = 8.0,
        hrIncreaseLow     = { 5, 10 },
        hrIncreaseNormal  = { 5, 10 },
        hrIncreaseHigh    = { 5, 10 },
        timeInSystem      = 1800,
        timeTillMaxEffect = 30,
        maxDose           = 4,
        viscosityChange   = 0
    },
    
    ["painkiller_100"] = {
        painReduce        = 1.0,
        hrIncreaseLow     = { 0, 1 },
        hrIncreaseNormal  = { 0, 1 },
        hrIncreaseHigh    = { 0, 1 },
        timeInSystem      = 120,
        timeTillMaxEffect = 30,
        maxDose           = 8,
        viscosityChange   = 0
    }
}