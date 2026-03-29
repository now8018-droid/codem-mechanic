Config = {}

Config.Framework = 'autodetect'        -- esx, oldesx, qb, oldqb or autodetect
Config.SQL = "oxmysql"                 -- oxmysql, ghmattimysql, mysql-async
Config.ItemImagesFolder = "nui://codem-inventory/html/itemimages/"
Config.MechanicThema = 'purple'        -- red , blue , purple, orange , white
Config.newManagementSystem = true     -- true is qb-banking false qb-managment
Config.CreateJobAccount = true         -- is only for qb-banking, if there is no data for profession in sql, it creates automatically
Config.InteractionHandler = "drawtext" -- drawtext - qb-target - ox-target
Config.ModifyWithYourCash = true      -- Modifications are not deducted from the cash register but from the person who modified the vehicle at that moment. || If false, the money is deducted from the socity coffers
Config.MoneyType = 'bank'              -- cash or bank
--[[
    - no_job
    everyone can access mechanic menu and bossmenu will disable
    - only_job
    only mechanic jobs you defined can access the mechanic menu and bossmenu will be useable
    - half_job
    if there is no mechanic other players can use the mechanic menu
]]
--
Config.MechanicMode = 'only_job' -- no_job, only_job, half_job

-- NPC Missions Settings
Config.EnableNPCMissions = true          -- true: NPC active, false: NPC disabled


Config.ExampleProfilePicture =
"https://cdn.discordapp.com/attachments/983471660684423240/1147567519712940044/example-pp.png"



Config.EnableRegisterKeyMapping = true
Config.EnableRegisterKeyMappingKey = "F7"
--[[
    if set to true adjust the keys down below by referencing this url
    -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

    if set to false adjust the keys down below by referencing this url
    -- https://docs.fivem.net/docs/game-references/controls/

]]
--


Config.JobMenuKey = 167         --- job menu open key  f6

Config.BillScript = "codemBillingv2" -- codemBilling - codemBillingv2 - okokBilling - jaksamBilling - esxdefault - qbdefault


Config.SocietyNameJob = {
    mechanic = 'mechanic',
    mechanic1 = 'mechanic1'
}


Config.MechanicSettings = {
    ['mechanic'] = { -- job name

        name = 'benny',
        label = 'Benny',
        mechanicMenuCoords = {
            vector3(-211.58, -1324.24, 30.47),
        },
        bossMenuCoords = {
            vector3(-200.97, -1318.24, 31.09),
        },
        bossMenuLabel = "Open Boss Menu",
        mechanicMenuLabel = "Open Mechanic Menu",
        bossGradeLevel = 4,
        blipSettings = {
            showBlip = true,
            sprite = 72,
            color = 4,
            scale = 0.8,
            label = "Benny",
            coords = vector3(-200.97, -1318.24, 31.09)
        }
    },
    ['mechanic1'] = { -- job name
        name = 'lscustom',
        label = 'Los Santos Custom',
        mechanicMenuCoords = {
            vector3(-338.83, -136.86, 38.59),
            vector3(-325.13, -134.0, 38.57)
        },
        bossMenuCoords = {
            vector3(-347.12, -133.3, 39.01)
        },
        bossMenuLabel = "Open Boss Menu",
        mechanicMenuLabel = "Open Mechanic Menu",
        bossGradeLevel = 4,
        blipSettings = {
            showBlip = true,
            sprite = 72,
            color = 4,
            scale = 0.8,
            label = "Los Santos Custom",
            coords = vector3(-347.12, -133.3, 39.01)
        }
    }
}
Config.EngineHoodatTheRearModel = {
    ['t20'] = true,
    ['adder'] = true,
}

Config.BlaclistVehicle = {
    ["sultanrs"] = true
}

Config.BlacklistedItems = { -- items you don't want to show up on lscustom inventory
    -- "water",
    -- "weapon_pistol"
}



Config.CategoryLocked = {
    ['upgrade'] = false,
    ['bodyparts'] = false,
    ['interiors'] = false,
    ['liveries'] = false,
    ['horns'] = false,
    ['neons'] = false,
    ['paint'] = false,
    ['extra'] = false,
    ['repair'] = false,
    ['clean'] = false,
    ['freecam'] = false,
}


Config.MechanicUpgradeDefaultPrice = {
    [11] = {
        label = "Engine",
        price = 2000,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modEngine", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,   -- Do false if you don't want the fee to be doubled,
        background = "enginelos",
        modId = 11,
        name = "engines",
        camName = "frontCam"
    },
    [13] = {
        label = "Transmission",
        price = 1500,
        locked = false,              -- If you want to lock the upgrade, set it to true
        modName = "modTransmission", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,         -- Do false if you don't want the fee to be doubled,
        background = "transmissionlos",
        modId = 13,
        name = "transmission",
        camName = "frontCam"
    },
    [15] = {
        label = "Suspension",
        price = 750,
        locked = false,            -- If you want to lock the upgrade, set it to true
        modName = "modSuspension", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,       -- Do false if you don't want the fee to be doubled
        background = "suspensionlos",
        modId = 15,
        name = "suspension",
        camName = "leftCam"
    },
    [12] = {
        label = "Brakes",
        price = 500,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modBrakes", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,   -- Do false if you don't want the fee to be doubled
        background = "brakeslos",
        modId = 12,
        name = "brakes",
        camName = "leftCam"
    },
    [16] = {
        label = "Armor",
        price = 4000,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modArmor", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,  -- Do false if you don't want the fee to be doubled
        background = "armorlos",
        modId = 16,
        name = "armor",
        camName = "mainCam"
    },
    [18] = {
        label = "Turbo",
        price = 3500,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modTurbo", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,  -- Do false if you don't want the fee to be doubled
        background = "turbolos",
        modId = 18,
        name = "turbo",
        camName = "frontCam",
        count = {
            { label = "Stock", name = "stockturbo", price = 0,    classPrice = 0, isFixedPrice = false },
            { label = "Turbo", name = "turbo",      price = 1000, classPrice = 0, isFixedPrice = false }
        }
    },

    [39] = {
        label = "Engine Block",
        price = 1200,
        locked = false,             -- If you want to lock the upgrade, set it to true
        modName = "modEngineBlock", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = true,        -- Do false if you don't want the fee to be doubled
        modId = 39,
        background = "engineblocklos",
        camName = "frontCam"
    },
    [40] = {
        label = "Air Filter",
        price = 550,
        locked = false,           -- If you want to lock the upgrade, set it to true
        modName = "modAirFilter", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,     -- Do false if you don't want the fee to be doubled
        name = "airfilter",
        modId = 40,
        background = "airfilterlos",
        camName = "frontCam"
    },
    [41] = {
        label = "Struts",
        price = 100,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modStruts", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,  -- Do false if you don't want the fee to be doubled
        name = "strut",
        modId = 41,
        background = "strutlos",
        camName = "frontCam"
    },

    [0] = {
        label = "Spoilers",
        price = 1500,
        locked = false,          -- If you want to lock the upgrade, set it to true
        modName = "modSpoilers", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,    -- Do false if you don't want the fee to be doubled
        modId = 0,
        name = "spoiler",
        background = "spoilerlos",
        camName = "rearCam"

    },
    [1] = {
        label = "Front Bumper",
        price = 1600,
        locked = false,             -- If you want to lock the upgrade, set it to true
        modName = "modFrontBumper", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,       --Do false if you don't want the fee to be doubled
        modId = 1,
        name = "frontbumper",
        background = "frontbumperlos",
        camName = "frontCam"
    },
    [2] = {
        label = "Rear Bumper",
        price = 1600,
        locked = false,            -- If you want to lock the upgrade, set it to true
        modName = "modRearBumper", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,      --Do false if you don't want the fee to be doubled
        modId = 2,
        name = "rearbumper",
        background = "rearbumperlos",
        camName = "rearCam"
    },
    [3] = {
        label = "Side Skirt",
        price = 1500,
        locked = false,           -- If you want to lock the upgrade, set it to true
        modName = "modSideSkirt", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,     --Do false if you don't want the fee to be doubled
        modId = 3,
        name = "sideskirts",
        background = "sideskirtlos",
        camName = "leftCam"
    },
    [4] = {
        label = "Exhaust",
        price = 750,
        locked = false,         -- If you want to lock the upgrade, set it to true
        modName = "modExhaust", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,   --Do false if you don't want the fee to be doubled
        modId = 4,
        name = "exhaust",
        background = "exhaustlos",
        camName = "rearCam"
    },
    [5] = {
        label = "Frame",
        price = 500,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modFrame", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 5,
        name = "rollcage",
        background = "rollcagelos",
        camName = "topCam"
    },
    [7] = {
        label = "Hood",
        price = 1000,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modHood",  --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 7,
        name = "hood",
        background = "hoodlos",
        camName = "frontCam"
    },
    [8] = {
        label = "Fender",
        price = 1100,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modFender", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,  --Do false if you don't want the fee to be doubled
        modId = 8,
        name = "fender",
        background = "fenderlos",
        camName = "leftCam"
    },
    [10] = {
        label = "Roof",
        price = 850,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modRoof",  --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 10,
        name = "roof",
        background = "rooflos",
        camName = "topCam"
    },

    [42] = {
        label = "Arc Cover",
        price = 950,
        locked = false,           -- If you want to lock the upgrade, set it to true
        modName = "modArchCover", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,     --Do false if you don't want the fee to be doubled
        modId = 42,
        name = "arccovers",
        background = "arccoverlos",
        camName = "lightCam",
    },
    [43] = {
        label = "Aerials",
        price = 100,
        locked = false,         -- If you want to lock the upgrade, set it to true
        modName = "modAerials", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,   --Do false if you don't want the fee to be doubled
        modId = 43,
        name = "aerial",
        background = "aeriallos",
        camName = "frontCam",
    },
    [48] = {
        label = "Liveries",
        price = 1000,
        removeprice = 200,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modLivery", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,  --Do false if you don't want the fee to be doubled
        modId = 48,
        name = "liveries",
        background = "liverylos",
        camName = "mainCam"
    },
    [14] = {
        label = "Horn",
        price = 100,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modHorns", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 14,
        name = "horn",
        background = "hornlos",
        camName = "mainCam"
    },
    [29] = {
        label = "Dashboard",
        price = 350,
        locked = false,           -- If you want to lock the upgrade, set it to true
        modName = "modDashboard", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,     --Do false if you don't want the fee to be doubled
        modId = 29,
        name = "dashboard",
        background = "dashlos",
        camName = "interiorCam"
    },
    [32] = {
        label = "Seat",
        price = 400,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modSeats", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 32,
        name = "seat",
        background = "seatlos",
        camName = "topCam"
    },
    [33] = {
        label = "Steering Wheel",
        price = 500,
        locked = false,               -- If you want to lock the upgrade, set it to true
        modName = "modSteeringWheel", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,         --Do false if you don't want the fee to be doubled
        modId = 33,
        name = "steeringwheel",
        background = "steringwheellos",
        camName = "wheelsteringCam"
    },
    [31] = {
        label = "Door Speaker",
        price = 300,
        locked = false,             -- If you want to lock the upgrade, set it to true
        modName = "modDoorSpeaker", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,       --Do false if you don't want the fee to be doubled
        modId = 31,
        name = "doorspeaker",
        background = "doorspeakerlos",
        camName = "leftCam"
    },
    [46] = {
        label = "Window Bead",
        price = 100,
        locked = false,         -- If you want to lock the upgrade, set it to true
        modName = "modWindows", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,   --Do false if you don't want the fee to be doubled
        modId = 46,
        name = "window",
        background = "windowlos",
        camName = "mainCam"
    },
    [23] = {
        label = "Wheel",
        price = 1000,
        locked = false,             -- If you want to lock the upgrade, set it to true
        modName = "modFrontWheels", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,       --Do false if you don't want the fee to be doubled
        modId = 23,
        name = "wheel",
        background = "wheellos",
        camName = "mainCam"

    },
    [996] = {
        label = "Neon",
        price = 675,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "neonColor", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,  --Do false if you don't want the fee to be doubled
        modId = 996,
        name = "neon",
        background = "neonlos",
        count = {
            { label = "Stock No Neon",  name = "stockneon",    price = 0, classPrice = 0, isFixedPrice = false },
            { label = "All Sides Neon", name = "allsidesneon", price = 0, classPrice = 0, isFixedPrice = false }
        }
    },
    [30] = {
        label = "Speedometer",
        price = 450,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modDial",  --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 30,
        name = "speedometer",
        background = "speedometerlos",
        camName = "wheelsteringCam"
    },
    [34] = {
        label = "Shifter",
        price = 450,
        locked = false,                -- If you want to lock the upgrade, set it to true
        modName = "modShifterLeavers", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,          --Do false if you don't want the fee to be doubled
        modId = 34,
        name = "shifter",
        background = "shifterlos",
        camName = "mainCam"
    },
    [999] = {
        --lights
        locked = false, -- If you want to lock the upgrade, set it to true
    },
    [28] = {
        label = "Ornaments",
        price = 100,
        locked = false,           -- If you want to lock the upgrade, set it to true
        modName = "modOrnaments", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,     --Do false if you don't want the fee to be doubled
        modId = 28,
        name = "ornaments",
        background = "ornamentslos",
        camName = "interiorCam"
    },
    [45] = {
        label = "Fuel Tank",
        price = 500,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modTank",  --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 45,
        name = "fueltank",
        background = "fueltanklos",
        camName = "mainCam"
    },
    [37] = {
        label = "Trunk",
        price = 500,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modTrunk", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 37,
        name = "trunk",
        background = "trunklos",
        camName = "mainCam"
    },
    [36] = {
        label = "Speaker",
        price = 350,
        locked = false,          -- If you want to lock the upgrade, set it to true
        modName = "modSpeakers", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,    --Do false if you don't want the fee to be doubled
        modId = 36,
        name = "speaker",
        background = "speakerlos",
        camName = "mainCam"
    },
    [44] = {
        label = "Wings",
        price = 100,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modTrimB", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 44,
        name = "wings",
        background = "wingslos",
        camName = "topCam",

    },
    [6] = {
        label = "Grille",
        price = 750,
        locked = false,        -- If you want to lock the upgrade, set it to true
        modName = "modGrille", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,  --Do false if you don't want the fee to be doubled
        modId = 6,
        name = "grille",
        background = "grillelos",
        camName = "lightCam",
    },
    [25] = {
        label = "Plate Holders",
        price = 750,
        locked = false,             -- If you want to lock the upgrade, set it to true
        modName = "modPlateHolder", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,       --Do false if you don't want the fee to be doubled
        modId = 25,
        name = "modplate",
        background = "platelos",
        camName = "rearCam",
    },
    [27] = {
        label = "Trim",
        price = 750,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modTrimA", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 27,
        name = "trim",
        background = "trimlos",
        camName = "topCam",
    },
    [38] = {
        label = "Hydraulics",
        price = 1000,
        locked = false,          -- If you want to lock the upgrade, set it to true
        modName = "modHydrolic", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,    --Do false if you don't want the fee to be doubled
        modId = 38,
        name = "hydraulics",
        background = "hydroliclos",
        camName = "leftCam",
    },
    [997] = {
        label = "Xenon",
        price = 0,
        locked = false,       -- If you want to lock the upgrade, set it to true
        modName = "modXenon", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false, --Do false if you don't want the fee to be doubled
        modId = 997,
        name = "xenon",
        background = "lightlos",
        camName = "lightCam",
        count = {
            { label = "Stock",       name = "stockxenon", price = 10 },
            { label = "Xenon",       name = "xenon",      price = 500 },
            { label = "Xenon Color", name = "xenoncolor", price = 10 },

        }
    },
    [994] = {
        label = "Window Tint",
        price = 250,
        locked = false,         -- If you want to lock the upgrade, set it to true
        modName = "windowTint", --It must be the same as the mod name in the vehicle save operations.
        isFixedPrice = false,   --Do false if you don't want the fee to be doubled
        modId = 994,
        name = "windowtint",
        background = "windowtint",
        camName = "leftCam",
        count = {
            { label = "Stock",  name = "tint-1", },
            { label = "None",   name = "tint0", },
            { label = "Tint-1", name = "tint1", },
            { label = "Tint-2", name = "tint2", },
            { label = "Tint-3", name = "tint3", },
            { label = "Tint-4", name = "tint4", }
        }
    },
    [991] = {
        label = "Wheels",
        price = 280,
        name = "wheel",
        camName = "wheelCam",
        background = "wheellos",
        count = {
            { label = "Wheel Types", text = "Examine All Wheel Types", name = "wheeltype" },
            -- { label = "Rim",         text = "Examine All Rim Colors",   name = "rimtype" },
            -- { label = "Tires",       text = "Examine All Tire Options", name = "tire" }
        }
    },
    [992] = {
        label = "Paint Color",
        name = "paintColor",
        background = "paintlos",
        count = {
            { label = "All Color",         price = 351, name = "allcolor" },
            { label = "Primary Color",     price = 352, name = "primarycolor" },
            { label = "Secondary Color",   price = 353, name = "secondarycolor" },
            { label = "Pearlescent Color", price = 353, name = "pearlescentcolor" },
            { label = "Wheel Color",       price = 354, name = "extracolor" },
            { label = "Tire Smoke",        price = 355, name = "tiresmoke" }

        }
    },
    [993] = {
        label = "Plate",
        price = 250,
        name = "plate",
        background = "platelos",
        camName = "rearCam",
        count = {
            { name = "pl1" },
            { name = "pl2" },
            { name = "pl3" },
            { name = "pl4" },
            { name = "pl5" },
        }
    },
    [1000] = {
        label = "Extra",
        price = 250,
        name = "extra",
        background = "extralos",
        camName = "mainCam",


    },
    wheeltype = {
        background = "wheeltype",
        label = "Wheel Types",
        name = "wheeltype",
        count = {
            { label = "Stock Wheels",    name = "stock" },
            { label = "Sport Wheels",    name = "sport" },
            { label = "Muscle Wheels",   name = "muscle" },
            { label = "Lowrider Wheels", name = "lowrider" },
            { label = "SUV Wheels",      name = "suv" },
            { label = "Offroad Wheels",  name = "offroad" },
            { label = "Tuner Wheels",    name = "tuner" },
            { label = "Bike Wheels",     name = "bike" },
            { label = "Highend Wheels",  name = "highend" }
        }
    },
    stock = {
        background = "wheellos",
        label = "Stock Wheel",
        name = "stock",
        price = 600,
        modId = "stockWheel"
    },
    sport = {
        background = "wheellos",
        label      = "Sport Wheel",
        name       = "sport",
        price      = 600,
        modId      = "sportWheel"
    },
    muscle = {
        background = "wheellos",
        label      = "Muscle Wheel",
        name       = "muscle",
        price      = 600,
        modId      = "muscleWheel"
    },
    suv = {
        background = "wheellos",
        label      = "Suv Wheel",
        name       = "suv",
        price      = 600,
        modId      = "suvWheel"
    },
    lowrider = {
        background = "wheellos",
        label      = "Lowrider Wheel",
        name       = "lowrider",
        price      = 600,
        modId      = "lowriderWheel"
    },
    offroad = {
        background = "wheellos",
        label      = "Offroad Wheel",
        name       = "offroad",
        price      = 600,
        modId      = "offroadWheel"
    },
    tuner = {
        background = "wheellos",
        label      = "Tuner Wheel",
        name       = "tuner",
        price      = 600,
        modId      = "tunerWheel"
    },
    bike = {
        background = "wheellos",
        label      = "Bike Wheel",
        name       = "bike",
        price      = 600,
        modId      = "bikeWheel"
    },
    highend = {
        background = "wheellos",
        label      = "Highend Wheel",
        name       = "highend",
        price      = 600,
        modId      = "highendWheel"
    },

}

Config.MechanicCategoriesSettings = {
    upgrade = {
        {
            name = "engines",
            label = "ENGINES",
            modId = 11,
            clip = "polygon(3.4% 0, 100% 0, 95% 100%, 0% 100%)",
            width = "71.2%",
            margin = "1.34vw",

        },
        {
            name = "transmission",
            label = "TRANSMISSION",
            modId = 13,
            clip = "polygon(2% 0, 100% 0, 96% 100%, 0% 100%)",
            width = "68.9%",
            margin = "1vw",

        },
        {
            name = "suspension",
            label = "SUSPENSION",
            clip = "polygon(2% 0, 100% 0, 97.5% 100%, 0% 100%)",
            modId = 15,
            width = "67.3%",
            margin = "0.7vw",

        },
        {
            name = "brakes",
            label = "BRAKES",
            clip = "polygon(1.5% 0, 100% 0, 98.5% 100%, 0% 100%)",
            width = "66.8%",
            modId = 12,
            margin = "0.5vw",

        },
        {
            name = "armor",
            label = "ARMOR",
            clip = "polygon(0% 0, 100% 0, 100% 100%, 0% 100%",
            width = "65.6%",
            modId = 16,
            margin = "0.45vw",

        },
        {
            name = "turbo",
            label = "TURBO",
            clip = "polygon(0% 0, 99% 0, 100% 100%, 1% 100%)",
            width = "66%",
            modId = 18,
            margin = "0.45vw",

        },
        {
            name = "engineblock",
            label = "ENGINE BLOCK",
            clip = "polygon(0% 0, 97.5% 0, 100% 100%, 2% 100%)",
            width = "67.4%",
            modId = 39,
            margin = "0.5vw",

        },
        {
            name = "airfilter",
            label = "AIR FILTER",
            clip = "polygon(0% 0, 96.5% 0, 100% 100%, 3% 100%)",
            width = "68.5%",
            modId = 40,
            margin = "0.75vw",

        },
        {
            name = "strut",
            label = "STRUT",
            clip = "polygon(0% 0, 95.5% 0, 100% 100%, 3% 100%)",
            width = "70%",
            modId = 41,
            margin = "1.15vw",

        },
    },
    bodyparts = {
        {
            name = "spoiler",
            label = "SPOILER",
            modId = 0,
            clip = "polygon(3.4% 0, 100% 0, 95% 100%, 0% 100%)",
            width = "71.2%",
            margin = "1.34vw"
        },
        {
            name = "frontbumper",
            label = "FRONT BUMPER",
            modId = 1,
            clip = "polygon(2% 0, 100% 0, 96% 100%, 0% 100%)",
            width = "68.9%",
            margin = "1vw"
        },
        {
            name = "rearbumper",
            label = "REAR BUMPER",
            clip = "polygon(2% 0, 100% 0, 97.5% 100%, 0% 100%)",
            width = "67.3%",
            modId = 2,
            margin = "0.7vw"
        },
        {
            name = "sideskirts",
            label = "SIDE SKIRTS",
            clip = "polygon(1.5% 0, 100% 0, 98.5% 100%, 0% 100%)",
            width = "66.8%",
            modId = 3,
            margin = "0.5vw"
        },
        {
            name = "exhaust",
            label = "EXHAUST",
            clip = "polygon(0% 0, 100% 0, 100% 100%, 0% 100%",
            width = "65.6%",
            modId = 4,
            margin = "0.45vw"
        },
        {
            name = "rollcage",
            label = "ROLL CAGE",
            clip = "polygon(0% 0, 99% 0, 100% 100%, 1% 100%)",
            width = "66%",
            modId = 5,
            margin = "0.45vw"
        },
        {
            name = "hood",
            label = "HOOD",
            clip = "polygon(0% 0, 97.5% 0, 100% 100%, 2% 100%)",
            width = "67.4%",
            modId = 7,
            margin = "0.5vw"
        },
        {
            name = "fender",
            label = "FENDER",
            clip = "polygon(0% 0, 96.5% 0, 100% 100%, 3% 100%)",
            width = "68.5%",
            modId = 8,
            margin = "0.75vw"
        },
        {
            name = "roof",
            label = "ROOF",
            clip = "polygon(0% 0, 95.5% 0, 100% 100%, 3% 100%)",
            width = "70%",
            modId = 10,
            margin = "1.15vw"
        },
        {
            name = "window",
            label = "WINDOW",
            clip = "polygon(0% 0, 94% 0, 100% 100%, 4.5% 100%)",
            width = "72.3%",
            modId = 46,
            margin = "1.6vw"
        },
        {
            name = "wheel",
            label = "WHEELS",
            modId = 991,
            clip = "polygon(3.4% 0, 100% 0, 95% 100%, 0% 100%)",
            width = "71.2%",
            margin = "1.34vw"
        },
        {
            name = "plates",
            label = "PLATES",
            modId = 993,
            clip = "polygon(2% 0, 100% 0, 96% 100%, 0% 100%)",
            width = "68.9%",
            margin = "1vw"
        },
        {
            name = "lights",
            label = "LIGHTS",
            clip = "polygon(2% 0, 100% 0, 97.5% 100%, 0% 100%)",
            width = "67.3%",
            margin = "0.7vw",
            modId = 997,
        },
        {
            name = "arccovers",
            label = "ARC COVERS",
            clip = "polygon(1.5% 0, 100% 0, 98.5% 100%, 0% 100%)",
            width = "66.8%",
            modId = 42,
            margin = "0.5vw"

        },
        {
            name = "aerial",
            label = "AERIAL",
            clip = "polygon(0% 0, 100% 0, 100% 100%, 0% 100%",
            width = "65.6%",
            margin = "0.45vw",
            modId = 43
        },
        {
            name = "windowtint",
            label = "WINDOW TINT",
            clip = "polygon(0% 0, 99% 0, 100% 100%, 1% 100%)",
            width = "66%",
            modId = 994,
            margin = "0.45vw"
        },
        {
            name = "wings",
            label = "WINGS",
            clip = "polygon(0% 0, 97.5% 0, 100% 100%, 2% 100%)",
            width = "67.4%",
            modId = 44,
            margin = "0.5vw"
        },
        {
            name = "grille",
            label = "GRILLE",
            clip = "polygon(0% 0, 96.5% 0, 100% 100%, 3% 100%)",
            width = "68.5%",
            modId = 6,
            margin = "0.75vw"
        },
        {
            name = "trim",
            label = "TRIM",
            clip = "polygon(0% 0, 95.5% 0, 100% 100%, 3% 100%)",
            width = "70%",
            modId = 27,
            margin = "1.15vw"
        },
        {
            name = "hydrolic",
            label = "HYDROLIC",
            clip = "polygon(0% 0, 94% 0, 100% 100%, 4.5% 100%)",
            width = "72.3%",
            modId = 38,
            margin = "1.6vw"
        }
    },
    interiors = {
        {
            name = "dash",
            label = "DASH",
            modId = 29,
            clip = "polygon(3.4% 0, 100% 0, 95% 100%, 0% 100%)",
            width = "71.2%",
            margin = "1.34vw"
        },
        {
            name = "door",
            label = "DOORS SPEAKERS",
            modId = 31,
            clip = "polygon(2% 0, 100% 0, 96% 100%, 0% 100%)",
            width = "68.9%",
            margin = "1vw"
        },
        {
            name = "seat",
            label = "SEATS",
            clip = "polygon(2% 0, 100% 0, 97.5% 100%, 0% 100%)",
            modId = 32,
            width = "67.3%",
            margin = "0.7vw"
        },
        {
            name = "steeringwheel",
            label = "STEERING WHEELS",
            clip = "polygon(1.5% 0, 100% 0, 98.5% 100%, 0% 100%)",
            width = "66.8%",
            modId = 33,
            margin = "0.5vw"
        },
        {
            name = "dial",
            label = "SPEEDOMETER",
            clip = "polygon(0% 0, 100% 0, 100% 100%, 0% 100%",
            width = "65.6%",
            modId = 30,
            margin = "0.45vw"
        },
        {
            name = "shifter",
            label = "SHIFTER LEAVERS",
            clip = "polygon(0% 0, 99% 0, 100% 100%, 1% 100%)",
            width = "66%",
            modId = 34,
            margin = "0.45vw"
        },
        {
            name = "ornaments",
            label = "ORNAMENTS",
            clip = "polygon(0% 0, 97.5% 0, 100% 100%, 2% 100%)",
            width = "67.4%",
            modId = 28,
            margin = "0.5vw"
        },
        {
            name = "fueltank",
            label = "FUEL TANKS",
            clip = "polygon(0% 0, 96.5% 0, 100% 100%, 3% 100%)",
            width = "68.5%",
            modId = 45,
            margin = "0.75vw"
        },
        {
            name = "trunk",
            label = "TRUNK",
            clip = "polygon(0% 0, 95.5% 0, 100% 100%, 3% 100%)",
            width = "70%",
            modId = 37,
            margin = "1.15vw"
        },
        {
            name = "speaker",
            label = "SPEAKERS",
            clip = "polygon(0% 0, 94% 0, 100% 100%, 4.5% 100%)",
            width = "72.3%",
            modId = 36,
            margin = "1.6vw"
        },
        {
            name = "modplate",
            label = "PLATE HOLDERS",
            modId = 25,
            clip = "polygon(3.4% 0, 100% 0, 95% 100%, 0% 100%)",
            width = "71.2%",
            margin = "1.34vw"
        },
    }

}


Config.ClassModifier = {
    ["M"] = 1.1,  -- For motorcyle
    ["C"] = 4.5,  -- Percent upgrade modifier price
    ["B"] = 6.0,  -- Percent upgrade modifier price
    ["A"] = 7.4,  -- Percent upgrade modifier price
    ["A+"] = 8.5, -- Percent upgrade modifier price
    ["S"] = 9.6,  -- Percent upgrade modifier price
    ["S+"] = 10.7 -- Percent upgrade modifier price
}