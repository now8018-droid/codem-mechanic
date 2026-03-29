NPCvehicle = false
NPCvehicleCoords = false
createNpcCoords = false
createNPC = false
money = 0
jobs = {}

function updateVehicleCard()
    local modCategories = { 11, 13, 12, 15, 16, 18 }
    local modCategoryNames = { 'engine', 'transmission', 'brakes', 'suspension', 'armor', 'turbo' }
    local modPercantages = {}
    local found = false
    for _, modCategories in ipairs(modCategories) do
        found = true
        local modCount = GetNumVehicleMods(playerVeh, modCategories)
        local currentMod = GetVehicleMod(playerVeh, modCategories)

        local percentage = 0
        if modCount > 0 and currentMod >= 0 then
            percentage = ((currentMod + 1) / modCount) * 100
        end

        local categoryName = modCategoryNames[_]
        modPercantages[categoryName] = percentage
    end
    local turboMod = IsToggleModOn(playerVeh, 18)
    if turboMod then
        modPercantages['turbo'] = 100
    end
    if found then
        NuiMessage('updateVehicleCard', modPercantages)
    end
end

function getNearestMechanic()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    for job, v in pairs(Config.MechanicSettings) do
        for _, coords in pairs(v.mechanicMenuCoords) do
            local dist = #(pedCoords - coords)
            if dist < 5.0 then
                return job
            end
        end
    end
    return false
end

function CheckCanUseMechanic(mechanic)
    if Config.MechanicMode == 'half_job' then
        if Config.MechanicSettings[mechanic] or Config.MechanicSettings[job] then
            if (jobs[mechanic] ~= nil and jobs[mechanic] == 0) or (Config.MechanicSettings[mechanic] or Config.MechanicSettings[job]) then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent("codem-mechanic:UpdateJobs")
AddEventHandler("codem-mechanic:UpdateJobs", function(_jobs)
    jobs = _jobs
    if Config.MechanicMode == 'half_job' then
        if Config.InteractionHandler == 'ox-target' then
            for __, mechanic in pairs(Config.MechanicSettings) do
                if CheckCanUseMechanic(__) then
                    for _, v in pairs(mechanic.mechanicMenuCoords) do
                        TriggerEvent("codem-mechanic:AddZone", v, 'mechanic-tuning-menu' .. __ .. '' .. _, {
                            {
                                name = 'mechanic-boss' .. __ .. '' .. _,
                                event = 'codem-mechanic:OpenMechanicMenu',
                                icon = 'fas fa-gears',
                                label = Config.Locales.OPEN_MECHANIC_MENU,
                            }
                        })
                    end
                else
                    TriggerEvent("codem-mechanic:RemoveZone", 'mechanic-tuning-menu')
                end
            end
        end
        if Config.InteractionHandler == 'qb-target' then
            for __, mechanic in pairs(Config.MechanicSettings) do
                if CheckCanUseMechanic(__) then
                    for _, v in pairs(mechanic.mechanicMenuCoords) do
                        TriggerEvent("codem-mechanic:AddZoneMechanic", v, mechanic)
                    end
                else
                    TriggerEvent("codem-mechanic:RemoveZoneByName", 'mechaniccodemmenu')
                end
            end
        end
    end
end)

Config.OpenTrigger = function()
    if Config.InteractionHandler == "drawtext" then
        CreateThread(function()
            while true do
                local wait = 1500
                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local mechanic = Config.MechanicSettings[job]

                local vehicle = GetVehiclePedIsIn(ped, false)
                if Config.MechanicMode == 'no_job' or CheckCanUseMechanic(getNearestMechanic()) then
                    local key = getNearestMechanic()
                    if key then
                        mechanic = Config.MechanicSettings[key]
                    end
                end
                if mechanic then
                    if tonumber(vehicle) ~= 0 then
                        for _, v in pairs(mechanic.mechanicMenuCoords) do
                            local dist = #(pedCoords - v)
                            if dist < 5.0 then
                                wait = 0

                                if not openMenuDrawText then
                                    DrawMarker(2, v.x, v.y,
                                        v.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15,
                                        255,
                                        255,
                                        255,
                                        255,
                                        false, false, false, true, false, false, false)
                                    DrawText3D(v.x, v.y,
                                        v.z + 0.8,
                                        mechanic.mechanicMenuLabel)
                                end
                                if Config.MechanicMode == 'only_job' then
                                    SetVehicleFuelLevel(vehicle, 100.0)
                                end
                                if IsControlJustPressed(0, 38) then
                                    if nuiLoaded then
                                        openMenu('mechanic', mechanic.label)
                                    else
                                        TriggerEvent('codem-mechanic:notification', Config.Locales.MENU_LOADING)
                                    end
                                end
                            end
                        end
                    end
                end
                Citizen.Wait(wait)
            end
        end)
    elseif Config.InteractionHandler == "qb-target" then
        local existData = {}

        RegisterNetEvent("codem-mechanic:AddZoneMechanic")
        AddEventHandler("codem-mechanic:AddZoneMechanic", function(coords, mechanic)
            local rand = math.random(1, 1000)
            local zoneName = "mechaniccodemmenu"..rand
            if existData[zoneName] then
                return
            end
            existData[zoneName] = true
            exports['qb-target']:AddBoxZone(zoneName, coords, 1.5, 1.6,
                {
                    name = zoneName,
                    heading = 12.0,
                    debugPoly = false,
                    minZ = coords.z - 1,
                    maxZ = coords.z + 1,
                }, {
                    options = {
                        {
                            num = 1,
                            type = "client",
                            icon = 'fas fa-gears',
                            label = mechanic.mechanicMenuLabel,
                            targeticon = 'fas fa-gears',
                            action = function()
                                openMenu('mechanic', mechanic.label)
                            end
                        }
                    },
                    distance = 2.5,
                })
        end)
        RegisterNetEvent("codem-mechanic:RemoveZone")
        AddEventHandler("codem-mechanic:RemoveZone", function()
            for zoneName, _ in pairs(existData) do
                exports['qb-target']:RemoveZone(zoneName)
                existData[zoneName] = false
            end
        end)

        RegisterNetEvent("codem-mechanic:RemoveZoneByName")
        AddEventHandler("codem-mechanic:RemoveZoneByName", function(name)
            if existData[name] then
                exports['qb-target']:RemoveZone(name)
                existData[name] = false
            end
        end)
    elseif Config.InteractionHandler == "ox-target" then
        local existData = {}
    
        RegisterNetEvent("codem-mechanic:AddZone")
        AddEventHandler("codem-mechanic:AddZone", function(coords, name, options)
            local zoneName = name
            local counter = 1
            while existData[zoneName] do
                counter = counter + 1
                zoneName = name .. counter
            end
            existData[zoneName] = true
           
            exports.ox_target:addBoxZone({
                name = zoneName,
                coords = coords,
                size = vec3(3, 3, 3),
                drawSprite = true,
                options = options
            })
        end)
    
        RegisterNetEvent("codem-mechanic:RemoveZone")
        AddEventHandler("codem-mechanic:RemoveZone", function(name)
            if existData[name] then
                exports.ox_target:removeZone(name)
                existData[name] = false
            end
        end)
    end
end




function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function getFindVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    local isMotorCycle = IsThisModelABike(model) or IsThisModelABicycle(model) or IsThisModelAQuadbike(model)
    local topSpeedKM = math.floor(GetVehicleEstimatedMaxSpeed(vehicle) * 3.6)
    local vehClass = "C"
    if isMotorCycle then
        vehClass = "M"
    elseif topSpeedKM < 160 then
        vehClass = "C"
    elseif topSpeedKM < 180 then
        vehClass = "B"
    elseif topSpeedKM < 260 then
        vehClass = "A"
    elseif topSpeedKM < 360 then
        vehClass = "A+"
    elseif topSpeedKM < 480 then
        vehClass = "S"
    else
        vehClass = "S+"
    end
    return vehClass
end

RegisterNetEvent('codem-mechanic:showProgressBar', function(text, time)
    if text and time then
        NuiMessage('showProgressBar', { label = text, time = time })
    end
end)

function repairVehicle(vehicle)
    NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_REPAIR_VEHICLE, time = 2 })
    Citizen.Wait(2500)
    SetVehicleFixed(vehicle)
end

function cleanVehicle(vehicle)
    NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_REPAIR_VEHICLE, time = 2 })
    SetVehicleDirtLevel(vehicle, 0.0)
end

function hideMenuOpen()
    --Write the events of the scripts you want to close when the mechanics menu opens.
end

function hideMenuClose()
    --Write the events of the scripts you want to open when the mechanic menu is closed.
end

RegisterNUICallback('billPlayer', function(data)
    if data then
        TriggerServerEvent('codem-mechanic:billPlayer', data)
    end
end)


function WaitForModel(model)
    if not IsModelValid(model) then
        return
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
    end

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function loaddict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

RegisterNUICallback('jobMenuOption', function(data)
    if data == 'repairthevehicle' then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.5) then
            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.5, 0, 71)
            if DoesEntityExist(vehicle) then
                SetVehicleDoorOpen(vehicle, 4, false, false)
                local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local animName = "machinic_loop_mechandplayer"
                LoadAnim(animDict)
                TaskPlayAnim(PlayerPedId(), animDict, animName, 2.0, 2.0, 15000, 16, 0, false, false, false)
                NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_REPAIR_VEHICLE, time = 15 })
                Citizen.Wait(15000)
                SetVehicleFixed(vehicle)
            end
        end
    end
    if data == 'cleanthevehicle' then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.5) then
            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.5, 0, 71)
            if DoesEntityExist(vehicle) then
                TaskStartScenarioInPlace(ply, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_CLEAN_VEHICLE, time = 10 })
                Citizen.Wait(11000)
                SetVehicleDirtLevel(vehicle, 0)
                ClearPedTasksImmediately(ply)
            end
        end
    end
    if data == 'pustthevehicle' then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.5) then
            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.5, 0, 71)
            if DoesEntityExist(vehicle) then
                print('push')
                NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_FLIP_VEHICLE, time = 10 })
                Citizen.Wait(5000)
                SetVehicleOnGroundProperly(vehicle)
                local carCoords = GetEntityRotation(vehicle, 2)
                SetEntityRotation(vehicle, carCoords[1], 0, carCoords[3], 2, true)
            end
        end
    end

    if data == 'getnpcmission' then
        while Core == nil do
            Wait(0)
        end

        if not Config.EnableNPCMissions then
            TriggerEvent('codem-mechanic:notification', Config.Locales.NPC_MISSION_DISABLED)
            return
        end
        if NPCvehicle then
            TriggerEvent('codem-mechanic:notification', Config.Locales.ACTIVE_MISSION)
        else
            CreateNpc()
        end
    end
end)

function RandomNameSelect()
    gender = math.random(1, 2)
    local SelectedName = nil
    if gender == 1 then
        SelectedName = NPC.MissionPed.ManName[math.random(1, #NPC.MissionPed.ManName)]
    else
        SelectedName = NPC.MissionPed.WomanName[math.random(1, #NPC.MissionPed.WomanName)]
    end

    return SelectedName
end

function CreateNpc()
    if not DoesEntityExist(NPCvehicle) then
        local random = math.random(1, #NPC.Mission)
        createNpcCoords = NPC.Mission[random]['npcCoords']
        money = NPC.Mission[random]['money']
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0)
        local npcName = RandomNameSelect()
        TriggerEvent('codem-mechanic:notification', string.format(Config.Locales.NPC_MISSION, npcName))
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0)
        if gender == 1 then
            model = NPC.MissionPed.ManHash[math.random(1, #NPC.MissionPed.ManHash)]
        else
            model = NPC.MissionPed.WomanHash[math.random(1, #NPC.MissionPed.WomanHash)]
        end
        WaitForModel(model)
        createNPC = CreatePed("PED_TYPE_PROSTITUTE", model, createNpcCoords.x, createNpcCoords.y,
            createNpcCoords.z - 0.98, createNpcCoords.w, true, false)
        FreezeEntityPosition(createNPC, true)
        SetEntityInvincible(createNPC, true)
        SetBlockingOfNonTemporaryEvents(createNPC, true)
        TaskStartScenarioInPlace(createNPC, "WORLD_HUMAN_SMOKING", 0, false)
        loaddict("switch@michael@parkbench_smoke_ranger")
        customerNpcBlip = AddBlipForCoord(createNpcCoords.x, createNpcCoords.y, createNpcCoords.z)
        SetBlipSprite(customerNpcBlip, 280)
        SetBlipColour(customerNpcBlip, 19)
        SetBlipRoute(customerNpcBlip, true)
        spawnNPCVehicle(NPC.Mission[random]['vehicleCoords'], NPC.Mission[random]['vehicleModel'],
            NPC.Mission[random]['mission'])
    end
end

function spawnNPCVehicle(coords, vehicleModel, missionname)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local model = type(vehicleModel) == 'number' and vehicleModel or joaat(vehicleModel)
        Core.Streaming.RequestModel(model)
        local vector = vec(coords[1], coords[2], coords[3])
        local vehicle = CreateVehicle(vehicleModel, vector.xyz, coords[4], true, true)

        if tonumber(vehicle) == 0 then
            ClearMission()
            return TriggerEvent('codem-mechanic:notification', 'Try Again')
        end
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(vehicle, 'OFF')

        RequestCollisionAtCoord(vector.xyz)
        NPCvehicle = vehicle
        NPCvehicleCoords = coords
        while not HasCollisionLoadedAroundEntity(vehicle) do
            Wait(0)
        end

        if missionname == 'enginerepair' then
            SetVehicleEngineHealth(vehicle, 150)
        elseif missionname == 'tirefix' then
            WheelP = math.random(0, 7)
            if WheelP == 0 then
                WhellBone = 'wheel_lf'
            elseif WheelP == 1 then
                WhellBone = 'wheel_rf'
            elseif WheelP == 7 then
                WhellBone = 'wheel_lr'
            elseif WheelP == 5 then
                WhellBone = 'wheel_rr'
            else
                WheelP = 0
                WhellBone = 'wheel_lf'
            end
            SetVehicleTyreBurst(vehicle, WheelP, true, 1000.0)
        end
        mission = missionname
    else
        model = type(vehicleModel) == 'string' and GetHashKey(vehicleModel) or vehicleModel
        if not IsModelInCdimage(model) then return end
        Core.Functions.LoadModel(model)
        local veh = CreateVehicle(vehicleModel, coords[1], coords[2], coords[3], coords[4],
            false)
        if tonumber(veh) == 0 then
            ClearMission()
            return TriggerEvent('codem-mechanic:notification', 'Try Again')
        end
        local netid = NetworkGetNetworkIdFromEntity(veh)
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        SetNetworkIdCanMigrate(netid, true)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehRadioStation(veh, 'OFF')
        SetVehicleFuelLevel(veh, 100.0)
        SetModelAsNoLongerNeeded(model)
        NPCvehicle = veh
        NPCvehicleCoords = coords
        if missionname == 'enginerepair' then
            SetVehicleEngineHealth(veh, 150)
        elseif missionname == 'tirefix' then
            WheelP = math.random(0, 7)
            if WheelP == 0 then
                WhellBone = 'wheel_lf'
            elseif WheelP == 1 then
                WhellBone = 'wheel_rf'
            elseif WheelP == 7 then
                WhellBone = 'wheel_lr'
            elseif WheelP == 5 then
                WhellBone = 'wheel_rr'
            else
                WheelP = 0
                WhellBone = 'wheel_lf'
            end
            SetVehicleTyreBurst(veh, WheelP, true, 1000.0)
        end
        mission = missionname
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local wait = 1500
        if NPCvehicle and NPCvehicleCoords then
            local coords = GetEntityCoords(ped)
            if mission == 'tirefix' then
                capot = GetEntityBoneIndexByName(NPCvehicle, WhellBone)
                local capotDistance = GetWorldPositionOfEntityBone(NPCvehicle, capot)
                local newCords = vector3(capotDistance.x, capotDistance.y, capotDistance.z)
                local d1, d2 = GetModelDimensions(GetEntityModel(NPCvehicle))
                local door = GetOffsetFromEntityInWorldCoords(NPCvehicle, d2.x + 0.2, 0.0, 0.0)
                local distance = #(coords - door)
                local wheeldist = #(coords - newCords)
                if distance < 1 then
                    wait = 0
                    DrawMarker(2, door.x, door.y, door.z + 1.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 0, 128, 0,
                        50, false, true, 2, nil, nil, false)
                    DrawText3D(door.x, door.y,
                        door.z + 0.3,
                        Config.Locales.CAR_JACK)
                    if IsControlJustPressed(0, 38) then
                        if CarJack then
                            CarJack = false
                        else
                            CarJack = true
                        end
                        UseTheJackFunction(NPCvehicle)
                    end
                end
                if wheeldist < 1 and CarJack and not StepOne then
                    wait = 0
                    DrawMarker(2, newCords.x, newCords.y, newCords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5,
                        0, 128, 0, 50, false, true, 2, nil, nil, false)
                    DrawText3D(newCords.x, newCords.y,
                        newCords.z + 0.3,
                        Config.Locales.FIX_TIRES)
                    if IsControlJustPressed(0, 38) then
                        FreezeEntityPosition(PlayerPedId(), true)
                        NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_CHANGE_WHEEL, time = 10 })
                        local ad = "anim@heists@box_carry@"
                        loaddict(ad)
                        TaskPlayAnim(PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0)
                        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                        propModel = 'prop_wheel_tyre'
                        propSpawned = CreateObject(GetHashKey(propModel), x, y, z + 0.2, true, true, true)
                        AttachEntityToEntity(propSpawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.10,
                            0.26, 0.32, 90.0, 110.0, 0.0, true, true, false, true, 1, true)
                        Citizen.Wait(2000)
                        DetachEntity(propSpawned, 1, 1)
                        DeleteObject(propSpawned)
                        ClearPedSecondaryTask(PlayerPedId())
                        ClearPedTasks(PlayerPedId())
                        propSpawned = nil
                        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                        local animName = "machinic_loop_mechandplayer"
                        LoadAnim(animDict)
                        TaskPlayAnim(PlayerPedId(), animDict, animName, 2.0, 2.0, 8000, 16, 0, false, false, false)
                        Citizen.Wait(8000)
                        FreezeEntityPosition(PlayerPedId(), false)
                        SetVehicleEngineHealth(NPCvehicle, 1000.0)
                        SetVehicleFixed(NPCvehicle)
                        SetVehicleDeformationFixed(NPCvehicle)
                        StepOne = true
                    end
                end
            else
                capot = GetEntityBoneIndexByName(NPCvehicle, 'engine')
                local capotDistance = GetWorldPositionOfEntityBone(NPCvehicle, capot)
                local newCords = vector3(capotDistance.x, capotDistance.y, capotDistance.z)
                local distance = #(coords - newCords)
                if distance < 2.0 and not StepOne then
                    wait = 0
                    DrawMarker(2, capotDistance.x, capotDistance.y, capotDistance.z + 1.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0,
                        0.5, 0.5, 0.5, 0, 128, 0, 50, false, true, 2, nil, nil, false)
                    DrawText3D(capotDistance.x, capotDistance.y,
                        capotDistance.z + 0.3,
                        Config.Locales.DRAW_TEXT_REPAIR_VEHICLE)
                    if IsControlJustPressed(0, 38) then
                        NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_REPAIR_VEHICLE, time = 15 })
                        local vehicle = GetClosestVehicle(capotDistance.x + 2.0, capotDistance.y, capotDistance.z,
                            5.5, 0, 71)
                        if DoesEntityExist(vehicle) then
                            SetVehicleDoorOpen(vehicle, 4, false, false)
                            local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                            local animName = "machinic_loop_mechandplayer"
                            LoadAnim(animDict)
                            TaskPlayAnim(PlayerPedId(), animDict, animName, 2.0, 2.0, 15000, 16, 0, false, false, false)
                            Citizen.Wait(15000)
                            SetVehicleEngineHealth(vehicle, 1000.0)
                            SetVehicleFixed(vehicle)
                            StepOne = true
                        end
                    end
                end
            end
            if mission == 'tirefix' then
                if createNpcCoords and not CarJack then
                    local distance2 = #(coords - vector3(createNpcCoords.x, createNpcCoords.y, createNpcCoords.z))
                    if distance2 < 2.0 then
                        wait = 0
                        if StepOne then
                            DrawText3D(createNpcCoords.x + 0.0, createNpcCoords.y,
                                createNpcCoords.z + 0.3,
                                Config.Locales.GIVE_MONEY)
                            if IsControlJustPressed(0, 38) then
                                FreezeEntityPosition(ped, true)
                                if (DoesEntityExist(createNPC) and not IsEntityDead(createNPC)) then
                                    loaddict("mp_safehouselost@")
                                    if (IsEntityPlayingAnim(createNPC, "mp_safehouselost@", "package_dropoff", 3)) then
                                        TaskPlayAnim(createNPC, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16,
                                            0, 0, 0, 0)
                                    else
                                        TaskPlayAnim(createNPC, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16,
                                            0, 0, 0, 0)
                                    end
                                end
                                Wait(2000)
                                tab = CreateObject(GetHashKey("hei_prop_heist_cash_pile"), 0, 0, 0, true, true, true)
                                AttachEntityToEntity(tab, createNPC, GetPedBoneIndex(createNPC, 57005), 0.10, 0.05, -0.02,
                                    90.0, 0.0, 0.0, true, true, false, true, 1, true)

                                Wait(4900)
                                FreezeEntityPosition(ped, false)

                                if tonumber(money) > 0 then
                                    JobSuccesMoney(tonumber(money))
                                else
                                    TriggerEvent('codem-mechanic:notification',
                                        Config.Locales.CONTACT_OWNER)
                                end

                                DeleteEntity(tab)
                                StepOne = false
                                FreezeEntityPosition(createNPC, false)

                                TaskEnterVehicle(createNPC, NPCvehicle, 20000, -1, 1.5, 1, 0)

                                Citizen.CreateThread(function()
                                    local timeout = 0
                                    while not IsPedInVehicle(createNPC, NPCvehicle, false) and timeout < 5000 do
                                        Citizen.Wait(500)
                                        timeout = timeout + 500
                                    end

                                    if IsPedInVehicle(createNPC, NPCvehicle, false) then
                                        TaskVehicleDriveWander(createNPC, NPCvehicle, 20.0, 786603)
                                        StepTwo = true
                                        Citizen.Wait(3000)
                                        ClearMission()
                                    end
                                end)
                            end
                        end
                    end
                end
            else
                if createNpcCoords then
                    local distance2 = #(coords - vector3(createNpcCoords.x, createNpcCoords.y, createNpcCoords.z))
                    if distance2 < 2.0 then
                        wait = 0
                        if StepOne then
                            DrawText3D(createNpcCoords.x + 0.0, createNpcCoords.y,
                                createNpcCoords.z + 0.3,
                                Config.Locales.GIVE_MONEY)
                            if IsControlJustPressed(0, 38) then
                                FreezeEntityPosition(ped, true)
                                if (DoesEntityExist(createNPC) and not IsEntityDead(createNPC)) then
                                    loaddict("mp_safehouselost@")
                                    if (IsEntityPlayingAnim(createNPC, "mp_safehouselost@", "package_dropoff", 3)) then
                                        TaskPlayAnim(createNPC, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16,
                                            0, 0, 0, 0)
                                    else
                                        TaskPlayAnim(createNPC, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16,
                                            0, 0, 0, 0)
                                    end
                                end
                                Wait(2000)
                                tab = CreateObject(GetHashKey("hei_prop_heist_cash_pile"), 0, 0, 0, true, true, true)
                                AttachEntityToEntity(tab, createNPC, GetPedBoneIndex(createNPC, 57005), 0.10, 0.05, -0.02,
                                    90.0, 0.0, 0.0, true, true, false, true, 1, true)

                                Wait(4900)
                                FreezeEntityPosition(ped, false)

                                if tonumber(money) > 0 then
                                    JobSuccesMoney(tonumber(money))
                                else
                                    TriggerEvent('codem-mechanic:notification',
                                        Config.Locales.CONTACT_OWNER)
                                end

                                DeleteEntity(tab)
                                StepOne = false
                                FreezeEntityPosition(createNPC, false)

                                TaskEnterVehicle(createNPC, NPCvehicle, 20000, -1, 1.5, 1, 0)

                                Citizen.CreateThread(function()
                                    local timeout = 0
                                    while not IsPedInVehicle(createNPC, NPCvehicle, false) and timeout < 5000 do
                                        Citizen.Wait(500)
                                        timeout = timeout + 500
                                    end

                                    if IsPedInVehicle(createNPC, NPCvehicle, false) then
                                        TaskVehicleDriveWander(createNPC, NPCvehicle, 20.0, 786603)
                                        StepTwo = true
                                        Citizen.Wait(3000)
                                        ClearMission()
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)




function ClearMission()
    SetPedAsNoLongerNeeded(createNPC)
    SetVehicleAsNoLongerNeeded(NPCvehicle)
    StepOne, StepTwo = false, false

    money = 0
    Wait(15000)
    DeleteEntity(createNPC)
    DeleteEntity(NPCvehicle)
    if DoesBlipExist(customerNpcBlip) then
        RemoveBlip(customerNpcBlip)
    end
    if DoesEntityExist(carJackObj) then
        DeleteEntity(carJackObj)
    end
    customerNpcBlip, NPCvehicle, NPCvehicleCoords, createNpcCoords, createNPC, mission, CarJack = false, false,
        false, false, false, nil, nil, false
end

function GetControlOfEntity(entity)
    local netTime = 15
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and netTime > 0 do
        NetworkRequestControlOfEntity(entity)
        Citizen.Wait(100)
        netTime = netTime - 1
    end
end

function SpawnJackProp(vehicle)
    local heading = GetEntityHeading(vehicle)
    local objPos = GetEntityCoords(vehicle)
    carJackObj = CreateObject(GetHashKey("prop_carjack"), objPos.x, objPos.y, objPos.z - 0.95, true, true, true)
    SetEntityHeading(carJackObj, heading)
    FreezeEntityPosition(carJackObj, true)
end

function UseTheJackFunction(vehicle)
    TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1.0)
    Citizen.Wait(1000)
    FreezeEntityPosition(vehicle, true)
    local vehPos = GetEntityCoords(vehicle)
    if not isJackRaised then
        SpawnJackProp(vehicle)
        Citizen.Wait(250)
    else
        if DoesEntityExist(carJackObj) then
            GetControlOfEntity(carJackObj)
            SetEntityAsMissionEntity(carJackObj)
            SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
        else
            carJackObj = GetClosestObjectOfType(vehPos.x, vehPos.y, vehPos.z, 1.2, GetHashKey("prop_carjack"), false,
                false, false)
            GetControlOfEntity(carJackObj)
            SetEntityAsMissionEntity(carJackObj)
            SetVehicleHasBeenOwnedByPlayer(carJackObj, true)
        end
    end
    local objPos = GetEntityCoords(carJackObj)
    -- Request & Load Animation:
    local anim_dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim_lib = "weed_crouch_checkingleaves_idle_02_inspector"
    LoadAnim(anim_dict)
    -- progbar:
    NuiMessage('showProgressBar', { label = Config.Locales.PROGRESS_BAR_CAR_JACK, time = 5.5 })
    -- Raise Jack Task:
    TaskPlayAnim(PlayerPedId(), anim_dict, anim_lib, 2.0, -3.5, -1, 1, false, false, false, false)
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
    local count = 5
    while true do
        vehPos = GetEntityCoords(vehicle)
        objPos = GetEntityCoords(carJackObj)
        if count > 0 then
            TaskPlayAnim(PlayerPedId(), anim_dict, anim_lib, 3.5, -3.5, -1, 1, false, false, false, false)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if not isJackRaised then
                SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z + 0.10), true, false, false, true)
                SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z + 0.10), true, false, false, true)
            else
                SetEntityCoordsNoOffset(vehicle, vehPos.x, vehPos.y, (vehPos.z - 0.10), true, false, false, true)
                SetEntityCoordsNoOffset(carJackObj, objPos.x, objPos.y, (objPos.z - 0.10), true, false, false, true)
            end
            FreezeEntityPosition(vehicle, true)
            FreezeEntityPosition(carJackObj, true)
            count = count - 1
        end
        if count <= 0 then
            ClearPedTasks(PlayerPedId())
            if isJackRaised then
                FreezeEntityPosition(vehicle, false)
                if DoesEntityExist(carJackObj) then
                    DeleteEntity(carJackObj)
                    DeleteObject(carJackObj)
                end
                carJackObj = nil
                isJackRaised = false
            else
                isJackRaised = true
            end
            usingJack = false
            break
        end
    end
    ClearPedTasks(PlayerPedId())
end