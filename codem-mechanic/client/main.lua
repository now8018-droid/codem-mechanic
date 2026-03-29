local basketItems = {}
local isVehicleCompleted = false
local nuiCallbackNuiMessage
local nuiCallbackCreateThread
local nuiCallbackRegisterNUICallback
local nuiCallbackAddEventHandler
local nuiCallbackTableUtils
local nuiCallbackListContains
local nuiCallbackGetNearbyPlayers
local nuiCallbackJobSuccesMoney

openMenuDrawText = false
nuiLoaded = false
playerVeh = nil
oldDataVehicle = false
key = false
lastMenuLabel = false

function sendNuiMessage(action, payload)
    while true do
        if nuiLoaded then
            break
        end
        Wait(0)
    end
    SendNUIMessage({
        action = action,
        payload = payload
    })
end

nuiCallbackNuiMessage = sendNuiMessage

nuiCallbackCreateThread = CreateThread

function checkNuiLoadedLoop()
    while true do
        if nuiLoaded then
            break
        end
        if NetworkIsSessionStarted() then
            sendNuiMessage("CHECK_NUI", {})
        end
        Wait(2000)
    end
end

nuiCallbackCreateThread(checkNuiLoadedLoop)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_LOADED = "loaded"

function handleNuiLoaded(data, cb)
    nuiLoaded = true
    sendNuiMessage("SET_LOCALES", Config.Locales)
    sendNuiMessage("SET_MODIFYCASH", Config.ModifyWithYourCash)
    sendNuiMessage("SET_NPC_MISSIONS", Config.EnableNPCMissions)
    cb("ok")
end

nuiCallbackRegisterNUICallback(NUI_EVENT_LOADED, handleNuiLoaded)

nuiCallbackCreateThread = Citizen.CreateThread

function mainThreadFunction()
    Config.OpenTrigger()
    while true do
        if nuiLoaded then
            break
        end
        Citizen.Wait(50)
    end

    sendNuiMessage("configDefaulPrice", Config.MechanicUpgradeDefaultPrice)
    sendNuiMessage("configMechanicSettings", Config.MechanicCategoriesSettings)
    sendNuiMessage("configCategoryLocked", Config.CategoryLocked)
    sendNuiMessage("configMechanicThema", Config.MechanicThema)
    sendNuiMessage("configEnableNPCMissions", Config.EnableNPCMissions)

    local playerKey = TriggerCallback("codem-mechanic:getKey")
    if playerKey then
        key = playerKey
    else
        key = false
    end

    if "no_job" == Config.MechanicMode then
        if "ox-target" == Config.InteractionHandler then
            for mechanicName, mechanicData in pairs(Config.MechanicSettings) do
                for _, coords in pairs(mechanicData.mechanicMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZone", coords, "mechanic-tuning-menu", {
                        {
                            name = "mechanic-boss",
                            event = "codem-mechanic:OpenMechanicMenu",
                            icon = "fas fa-gears",
                            label = Config.Locales.OPEN_MECHANIC_MENU
                        }
                    })
                end
            end
        end
        if "qb-target" == Config.InteractionHandler then
            for mechanicName, mechanicData in pairs(Config.MechanicSettings) do
                for _, coords in pairs(mechanicData.mechanicMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZoneMechanic", coords, mechanicData)
                end
            end
        end
    end
end

nuiCallbackCreateThread(mainThreadFunction)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_OPEN_MECHANIC_MENU = "codem-mechanic:OpenMechanicMenu"
nuiCallbackRegisterNUICallback(NET_EVENT_OPEN_MECHANIC_MENU)

nuiCallbackAddEventHandler = AddEventHandler

function openMechanicMenuHandler()
    local jobConfig = Config.MechanicSettings[job]
    if "no_job" ~= Config.MechanicMode then
        local nearestMechanic, _, _ = getNearestMechanic()
        if not CheckCanUseMechanic(nearestMechanic) then
            goto lbl_22
        end
    end

    local nearestMechanic = getNearestMechanic()
    if nearestMechanic then
        jobConfig = Config.MechanicSettings[nearestMechanic]
    end

    ::lbl_22::
    if jobConfig then
        openMenu("mechanic", jobConfig.label)
    end
end

nuiCallbackAddEventHandler(NET_EVENT_OPEN_MECHANIC_MENU, openMechanicMenuHandler)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_OPEN_MECHANIC_JOB_MENU = "codem-mechanic:OpenMechanicJobMenu"
nuiCallbackRegisterNUICallback(NET_EVENT_OPEN_MECHANIC_JOB_MENU)

nuiCallbackAddEventHandler = AddEventHandler

function openMechanicJobMenuHandler()
    local jobConfig = Config.MechanicSettings[job]
    if jobConfig then
        openMenu("jobmenu", jobConfig.label)
    end
end

nuiCallbackAddEventHandler(NET_EVENT_OPEN_MECHANIC_JOB_MENU, openMechanicJobMenuHandler)

nuiCallbackCreateThread = Citizen.CreateThread

function jobMenuKeyListenerThread()
    if Config.EnableRegisterKeyMapping then
        RegisterCommand("mechanicmenu", function()
            local jobConfig = Config.MechanicSettings[job]
            if jobConfig then
                if nuiLoaded then
                    openMenu("jobmenu", jobConfig.label)
                end
            end
        end)
        RegisterKeyMapping("mechanicmenu", "Mechanic Menu", "keyboard", Config.EnableRegisterKeyMappingKey)
    else
        CreateThread(function()
            while true do
                local jobConfig = Config.MechanicSettings[job]
                local waitTime = 2000
                if jobConfig then
                    waitTime = 2
                    if IsControlJustPressed(0, Config.JobMenuKey) then
                        openMenu("jobmenu", jobConfig.label)
                    end
                end
                Citizen.Wait(waitTime)
            end
        end)
    end
end

nuiCallbackCreateThread(jobMenuKeyListenerThread)

function openMenu(menuType, menuLabel)
    while true do
        if Core ~= nil then
            break
        end
        Wait(0)
    end

    if "mechanic" == menuType then
        local pedInDriverSeat = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1)
        if pedInDriverSeat ~= PlayerPedId() then
            return
        end

        lastMenuLabel = menuLabel
        playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)

        local vehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh))
        local lowerVehicleModelName = vehicleModelName.lower(vehicleModelName)

        if Config.BlaclistVehicle[lowerVehicleModelName] then
            playerVeh = nil
            TriggerEvent("codem-mechanic:notification", Config.Locales.CANT_MODIFY)
            return
        end

        CreateCamVehicle()
        SetNuiFocus(true, true)
        openMenuDrawText = true

        if not oldDataVehicle then
            oldDataVehicle = GetVehicleProperties(playerVeh)
        end

        local playerAccount = TriggerCallback("codem-mechanic:getAccount")
        local mechanicVault = TriggerCallback("codem-mechanic:getMechanicVault")
        local jobConfig = Config.MechanicSettings[job]

        if "no_job" ~= Config.MechanicMode then
            local nearestMechanic, _, _ = getNearestMechanic()
            local canUseMechanic = CheckCanUseMechanic(nearestMechanic)
            if canUseMechanic and not jobConfig then
                mechanicVault = playerAccount.cash
            end
        end

        if Config.ModifyWithYourCash then
            local playerCash = TriggerCallback("codem-mechanic:getPlayerAccount")
            mechanicVault = playerCash
        end

        sendNuiMessage("openmenu", {
            menu = menuType,
            profileAccount = playerAccount,
            vault = mechanicVault,
            mechanicLabel = menuLabel
        })
        Citizen.Wait(500)

        if "no_job" ~= Config.MechanicMode then
            local nearestMechanic, _, _ = getNearestMechanic()
            if not CheckCanUseMechanic(nearestMechanic) then
                goto lbl_122
            end
        end
        sendNuiMessage("hidebillplayer")
        ::lbl_122::

        updateVehicleCard()
        changeCamera("mainCam")
        sendNuiMessage("updateVehicleBasket", basketItems)
        hideMenuOpen()
        TriggerServerEvent("codem-mechanic:server:StartModity", NetworkGetNetworkIdFromEntity(playerVeh), oldDataVehicle)

    elseif "jobmenu" == menuType then
        SetNuiFocus(true, true)
        sendNuiMessage("openmenu", {
            menu = menuType
        })
    end
end

nuiCallbackOpenMenu = openMenu

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_NOTIFICATION = "codem-mechanic:notification"

function handleNotification(message)
    if message then
        sendNuiMessage("SET_NOTIFICATION", message)
    end
end

nuiCallbackRegisterNUICallback(NET_EVENT_NOTIFICATION, handleNotification)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_REFRESH_VAULT = "codem-mechanic:RefreshMechanicVault"

function handleRefreshMechanicVault(vaultBalance)
    sendNuiMessage("RefreshMechanicVault", vaultBalance)
end

nuiCallbackRegisterNUICallback(NET_EVENT_REFRESH_VAULT, handleRefreshMechanicVault)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_VEHICLE_MECHANIC_COMPLETE = "vehicleMechanicComplete"

function handleVehicleMechanicComplete(totalPrice)
    totalPrice = tonumber(totalPrice)

    local mechanicVault = TriggerCallback("codem-mechanic:getMechanicVault")
    local playerAccount = TriggerCallback("codem-mechanic:getAccount")
    local currentBalance = mechanicVault

    if "no_job" ~= Config.MechanicMode then
        local nearestMechanic, _, _ = getNearestMechanic()
        if not CheckCanUseMechanic(nearestMechanic) then
            goto lbl_29
        end
    end

    local jobConfig = Config.MechanicSettings[job]
    if jobConfig then
    else
        currentBalance = playerAccount.cash
    end
    ::lbl_29::

    if Config.ModifyWithYourCash then
        local playerCash = TriggerCallback("codem-mechanic:getPlayerAccount")
        currentBalance = playerCash
    end

    if tonumber(currentBalance) < tonumber(totalPrice) then
        TriggerEvent("codem-mechanic:notification", Config.Locales.NOT_ENOUGH_MONEY_CASH)
        return
    end

    TriggerServerEvent("codem-mechanic:vehicleMechanicComplete", totalPrice)
    isVehicleCompleted = true
end

nuiCallbackRegisterNUICallback(NUI_EVENT_VEHICLE_MECHANIC_COMPLETE, handleVehicleMechanicComplete)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_COMPLETE_VEHICLE = "codem-mechanic:completeVehicle"

function handleCompleteVehicle()
    basketItems = {}
    sendNuiMessage("updateVehicleBasket", basketItems)
end

nuiCallbackRegisterNUICallback(NET_EVENT_COMPLETE_VEHICLE, handleCompleteVehicle)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SHOW_NEARBY_PLAYER_BILL = "showNearbyPlayerBill"

function handleShowNearbyPlayerBill(targetServerId)
    if targetServerId then
        TriggerServerEvent("codem-mechanic:showOtherBill", targetServerId)
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SHOW_NEARBY_PLAYER_BILL, handleShowNearbyPlayerBill)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_SEND_SHOW_BILL = "codem-mechanic:sendShowBill"

function handleSendShowBill(billData)
    if billData then
        SetNuiFocus(true, true)
        sendNuiMessage("showBill", billData)
    end
end

nuiCallbackRegisterNUICallback(NET_EVENT_SEND_SHOW_BILL, handleSendShowBill)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CLOSE_OTHER_SUMMURY_BILL = "closeOtherSummuryBill"

function handleCloseOtherSummuryBill()
    SetNuiFocus(false, false)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CLOSE_OTHER_SUMMURY_BILL, handleCloseOtherSummuryBill)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CLEAR_VEHICLE_COLOR = "clearVehicleColor"

function handleClearVehicleColor()
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            ClearVehicleCustomPrimaryColour(playerVeh)
            ClearVehicleCustomSecondaryColour(playerVeh)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CLEAR_VEHICLE_COLOR, handleClearVehicleColor)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SET_VEHICLE_COLOR = "setVehicleColor"

function handleSetVehicleColor(data)
    SetVehicleModKit(playerVeh, 0)
    local primaryColor, secondaryColor = GetVehicleExtraColours(playerVeh)

    if "allcolor" == data.modname then
        ClearVehicleCustomPrimaryColour(playerVeh)
        ClearVehicleCustomSecondaryColour(playerVeh)
        SetVehicleColours(playerVeh, data.color, data.color)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "allcolor" == item.modId then
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[2].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[2].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "allcolor",
                price = Config.MechanicUpgradeDefaultPrice[992].count[2].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[2].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    end

    if "primarycolor" == data.modname then
        local r, g, b = data.color[1], data.color[2], data.color[3]
        SetVehicleCustomPrimaryColour(playerVeh, r, g, b)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "primarycolor" == item.modId then
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[3].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[3].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "primarycolor",
                price = Config.MechanicUpgradeDefaultPrice[992].count[3].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[3].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    elseif "secondarycolor" == data.modname then
        local r, g, b = data.color[1], data.color[2], data.color[3]
        SetVehicleCustomSecondaryColour(playerVeh, r, g, b)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "secondarycolor" == item.modId then
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[4].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[4].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "secondarycolor",
                price = Config.MechanicUpgradeDefaultPrice[992].count[4].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[4].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    elseif "extracolor" == data.modname then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(playerVeh)
        SetVehicleExtraColours(playerVeh, pearlescentColor, data.color)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "extracolor" == item.modId then
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[5].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[5].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "extracolor",
                price = Config.MechanicUpgradeDefaultPrice[992].count[5].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[5].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    elseif "pearlescentcolor" == data.modname then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(playerVeh)
        SetVehicleExtraColours(playerVeh, data.color, wheelColor)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "extracolor" == item.modId then -- Pearlescent color shares modId with extracolor
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[5].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[5].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "extracolor", -- Pearlescent color shares modId with extracolor
                price = Config.MechanicUpgradeDefaultPrice[992].count[5].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[5].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    elseif "tiresmoke" == data.modname then
        local r, g, b = data.color[1], data.color[2], data.color[3]
        ToggleVehicleMod(playerVeh, 20, true)
        SetVehicleTyreSmokeColor(playerVeh, r, g, b)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetVehicleBurnout(vehicle, true)
        TaskVehicleTempAction(playerPed, vehicle, 23, 5000)

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if "tiresmoke" == item.modId then
                item.price = Config.MechanicUpgradeDefaultPrice[992].count[6].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[992].count[6].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = "tiresmoke",
                price = Config.MechanicUpgradeDefaultPrice[992].count[6].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[992].count[6].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    elseif "xenoncolor" == data.modname then
        SetVehicleHeadlightsColour(playerVeh, data.color)
    elseif "allsidesneon" == data.modname then
        local r, g, b = data.color[1], data.color[2], data.color[3]
        SetVehicleNeonLightsColour(playerVeh, r, g, b)
        sendNuiMessage("updateStockNumber", {
            modId = 996,
            stock = 1
        })

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if tonumber(item.modId) == 996 then
                item.price = Config.MechanicUpgradeDefaultPrice[996].price
                item.index = ""
                item.label = Config.MechanicUpgradeDefaultPrice[996].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = 996,
                price = Config.MechanicUpgradeDefaultPrice[996].price,
                index = "",
                label = Config.MechanicUpgradeDefaultPrice[996].label
            })
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SET_VEHICLE_COLOR, handleSetVehicleColor)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_FORCE_DEFAULT_VEHICLE = "codem-mechanic:client:ForceDefaultVehicle"

function handleForceDefaultVehicle(netId, vehicleProperties)
    SetVehicleProperties(NetworkGetEntityFromNetworkId(netId), vehicleProperties)
    SetVehicleLights(NetworkGetEntityFromNetworkId(netId), 0)
    FreezeEntityPosition(NetworkGetEntityFromNetworkId(netId), false)
    SetVehicleBurnout(NetworkGetEntityFromNetworkId(netId), false)
    for i = 0, 7 do
        if GetVehicleDoorAngleRatio(NetworkGetEntityFromNetworkId(netId), i) > 0 then
            SetVehicleDoorShut(NetworkGetEntityFromNetworkId(netId), i, false)
        end
    end
end

nuiCallbackRegisterNUICallback(NET_EVENT_FORCE_DEFAULT_VEHICLE, handleForceDefaultVehicle)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_HORN_VEHICLE = "hornVehicle"

function handleHornVehicle()
    StartVehicleHorn(playerVeh, 5000, 0, false)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_HORN_VEHICLE, handleHornVehicle)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_STOCK_NEON = "stockNeon"

function handleStockNeon()
    SetVehicleNeonLightsColour(playerVeh, 255, 255, 255)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_STOCK_NEON, handleStockNeon)

nuiCallbackTableUtils = table

function tableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

nuiCallbackTableUtils.contains = tableContains

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_DELETE_VEHICLE_BASKET = "deleteVehicleBasket"

function handleDeleteVehicleBasket(item)
    local blacklistedMods = {
        "allcolor", "primarycolor", "secondarycolor", "extracolor", "tiresmoke", "xenoncolor",
        "sport", "muscle", "lowrider", "stock", "suv", "offroad", "tuner", "bike", "highend",
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
    }

    if tableContains(blacklistedMods, item.modId) then
        TriggerEvent("codem-mechanic:notification", Config.Locales.CANT_REMOVE)
        return
    end

    local currentModValue = GetVehicleMod(playerVeh, tonumber(item.modId))
    local modConfig = Config.MechanicUpgradeDefaultPrice[tonumber(item.modId)]

    if not modConfig or not modConfig.modName then
        TriggerEvent("codem-mechanic:notification", Config.Locales.MOD_NAME_NIL)
        sendNuiMessage("resultValue")
        return
    end

    local modName = modConfig.modName
    local stockValue = -1

    if tonumber(item.modId) == 18 then -- Turbo
        ToggleVehicleMod(playerVeh, 18, false)
        stockValue = IsToggleModOn(playerVeh, 18) and 1 or 0 -- Get current state, 0 if off
        for i, basketItem in ipairs(basketItems) do
            if tonumber(basketItem.modId) == tonumber(item.modId) then
                table.remove(basketItems, i)
                break
            end
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
        sendNuiMessage("updateStockNumberDelete", {
            modId = item.modId,
            stock = stockValue
        })
        return
    end

    if tonumber(item.modId) == 48 then -- Livery
        local liveryCount = GetVehicleLiveryCount(playerVeh)
        SetVehicleModKit(playerVeh, 0)
        if liveryCount == -1 then -- Special case for vehicles with no liveries
            if oldDataVehicle and oldDataVehicle.modLivery ~= nil then
                SetVehicleLivery(playerVeh, tonumber(oldDataVehicle.modLivery))
                SetVehicleMod(playerVeh, 48, tonumber(oldDataVehicle.modLivery))
            else
                SetVehicleMod(playerVeh, 48, tonumber(-1))
                SetVehicleLivery(playerVeh, -1)
            end
        else
            if oldDataVehicle and oldDataVehicle.modLivery ~= nil then
                SetVehicleLivery(playerVeh, tonumber(oldDataVehicle.modLivery))
            else
                SetVehicleLivery(playerVeh, tonumber(0))
            end
        end
        for i, basketItem in ipairs(basketItems) do
            if tonumber(basketItem.modId) == tonumber(item.modId) then
                table.remove(basketItems, i)
                break
            end
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
        sendNuiMessage("updateStockNumberDelete", {
            modId = item.modId,
            stock = 0
        }) -- Livery defaults to 0
        return
    end

    if tonumber(item.modId) == 996 then -- Neon color (fixed price)
        for i, basketItem in ipairs(basketItems) do
            if tonumber(basketItem.modId) == tonumber(item.modId) then
                table.remove(basketItems, i)
                break
            end
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
        SetVehicleNeonLightsColour(playerVeh, 255, 255, 255) -- Reset neon color to white
        return
    end

    local foundInOldData = false
    for k, v in pairs(oldDataVehicle) do
        if k == modName then
            foundInOldData = true
            SetVehicleMod(playerVeh, tonumber(item.modId), -1) -- Revert to default
            break
        end
    end

    if foundInOldData then
        for i, basketItem in ipairs(basketItems) do
            if tonumber(basketItem.modId) == tonumber(item.modId) then
                table.remove(basketItems, i)
                break
            end
        end
        sendNuiMessage("updateVehicleBasket", basketItems)
        stockValue = GetVehicleMod(playerVeh, tonumber(item.modId))
        sendNuiMessage("updateStockNumberDelete", {
            modId = item.modId,
            stock = stockValue
        })
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_DELETE_VEHICLE_BASKET, handleDeleteVehicleBasket)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SELECT_MECHANIC_CATEGORY_ITEM = "selectMechanicCategoryItem"

function handleSelectMechanicCategoryItem(modId)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            local modConfig = Config.MechanicUpgradeDefaultPrice[tonumber(modId)]
            if not modConfig or not modConfig.modName then
                TriggerEvent("codem-mechanic:notification", Config.Locales.MOD_NAME_NIL)
                sendNuiMessage("resultValue")
                return
            end

            local vehicleClass = getFindVehicle(playerVeh)
            local price = modConfig.price or 258258
            local stock = GetVehicleMod(playerVeh, tonumber(modId))
            local classPrice = Config.ClassModifier[vehicleClass] or "C"
            local isFixedPrice = modConfig.isFixedPrice

            SetVehicleModKit(playerVeh, 0)
            local camName = modConfig.camName

            local vehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh))
            local lowerVehicleModelName = vehicleModelName.lower(vehicleModelName)

            if "M" == vehicleClass then
                changeCamera("mainCam")
                local modCount = GetNumVehicleMods(playerVeh, tonumber(modId))
                sendNuiMessage("mechanicCategoryResult", {
                    modCount = modCount,
                    modId = tonumber(modId),
                    stock = stock,
                    price = price,
                    classPrice = classPrice,
                    isFixedPrice = isFixedPrice
                })
                return
            end

            local engineHoodAtRear = Config.EngineHoodatTheRearModel[lowerVehicleModelName]
            local doorAngleRatio = GetVehicleDoorAngleRatio(playerVeh, 4)

            local affectedByDoor4 = modId == 11 or modId == 13 or modId == 18 or modId == 39 or modId == 40 or modId == 41

            if engineHoodAtRear then
                if affectedByDoor4 then
                    changeCamera("rearCam")
                    if doorAngleRatio < 0.5 then
                        SetVehicleDoorOpen(playerVeh, 4, false)
                    end
                else
                    if camName then
                        changeCamera(camName)
                    end
                    if doorAngleRatio > 0 then
                        SetVehicleDoorShut(playerVeh, 4, false)
                    end
                end
            else
                if camName then
                    changeCamera(camName)
                end
                if affectedByDoor4 then
                    if doorAngleRatio < 0.5 then
                        SetVehicleDoorOpen(playerVeh, 4, false)
                    end
                elseif doorAngleRatio > 0 then
                    SetVehicleDoorShut(playerVeh, 4, false)
                end

                local door1AngleRatio = GetVehicleDoorAngleRatio(playerVeh, 1)
                if modId == 31 then
                    if door1AngleRatio < 0.5 then
                        SetVehicleDoorOpen(playerVeh, 1, false, false)
                    end
                elseif door1AngleRatio > 0 then
                    SetVehicleDoorShut(playerVeh, 1, false)
                end
            end

            stock = 0 -- Reset for livery logic

            if tonumber(modId) == 48 then -- Livery
                local liveryCount = GetVehicleLiveryCount(playerVeh)
                if liveryCount == -1 then -- Special case for vehicles with no livery functionality
                    local numMod48 = GetNumVehicleMods(playerVeh, 48)
                    if numMod48 ~= nil then
                        if numMod48 > 0 then
                            sendNuiMessage("mechanicCategoryResult", {
                                modCount = tonumber(GetNumVehicleMods(playerVeh, 48)),
                                modId = tonumber(modId),
                                stock = stock,
                                price = price,
                                classPrice = classPrice,
                                isFixedPrice = isFixedPrice
                            })
                            GetVehicleMod(playerVeh, 48)
                            return
                        end
                    end
                else
                    local currentLivery = GetVehicleLivery(playerVeh)
                    stock = currentLivery or 0
                    if not currentLivery then
                        stock = 0
                    end
                    sendNuiMessage("mechanicCategoryResult", {
                        modCount = liveryCount,
                        modId = tonumber(modId),
                        stock = stock,
                        price = price,
                        classPrice = classPrice,
                        isFixedPrice = isFixedPrice
                    })
                    sendNuiMessage("updateStockNumber", {
                        modId = 48,
                        stock = tonumber(stock)
                    })
                    return
                end
            end

            local modCount = GetNumVehicleMods(playerVeh, tonumber(modId))
            sendNuiMessage("mechanicCategoryResult", {
                modCount = modCount,
                modId = tonumber(modId),
                stock = stock,
                price = price,
                classPrice = classPrice,
                isFixedPrice = isFixedPrice
            })
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SELECT_MECHANIC_CATEGORY_ITEM, handleSelectMechanicCategoryItem)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_WINDOW_TINT = "changeVehicleWindowTint"

function handleChangeVehicleWindowTint(data)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            SetVehicleModKit(playerVeh, 0)
            SetVehicleWindowTint(playerVeh, data.index)

            local foundInBasket = false
            for _, item in ipairs(basketItems) do
                if tonumber(item.modId) == 994 then
                    item.price = Config.MechanicUpgradeDefaultPrice[994].price
                    item.index = data.index
                    item.label = Config.MechanicUpgradeDefaultPrice[994].label
                    foundInBasket = true
                    break
                end
            end
            if not foundInBasket then
                table.insert(basketItems, {
                    modId = 994,
                    price = Config.MechanicUpgradeDefaultPrice[994].price,
                    index = data.index,
                    label = Config.MechanicUpgradeDefaultPrice[994].label
                })
            end
            sendNuiMessage("updateStockNumber", {
                modId = 994,
                stock = GetVehicleWindowTint(playerVeh)
            })
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_WINDOW_TINT, handleChangeVehicleWindowTint)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_CAMERA = "changeVehicleCamera"

function handleChangeCamera(modId)
    local camName = Config.MechanicUpgradeDefaultPrice[tonumber(modId)].camName
    if camName then
        local vehicleClass = getFindVehicle(playerVeh)
        if "M" == vehicleClass then
            changeCamera("mainCam")
            return
        end

        local affectedByDoor4 = modId == 11 or modId == 13 or modId == 18 or modId == 39 or modId == 40 or modId == 41

        if affectedByDoor4 then
            local vehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh))
            local lowerVehicleModelName = vehicleModelName.lower(vehicleModelName)
            local engineHoodAtRear = Config.EngineHoodatTheRearModel[lowerVehicleModelName]
            if not engineHoodAtRear then
                changeCamera(camName)
            end
        else
            changeCamera(camName)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_CAMERA, handleChangeCamera)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_TURBO_OPEN = "turboOpen"

function handleTurboOpen()
    local doorAngleRatio = GetVehicleDoorAngleRatio(playerVeh, 4)
    if doorAngleRatio < 0.5 then
        SetVehicleDoorOpen(playerVeh, 4, false, false)
    end
    sendNuiMessage("updateStockNumber", {
        modId = 18,
        stock = IsToggleModOn(playerVeh, 18) and 1 or 0
    })
end

nuiCallbackRegisterNUICallback(NUI_EVENT_TURBO_OPEN, handleTurboOpen)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_XENON_OPEN = "xenonOpen"

function handleXenonOpen()
    SetVehicleModKit(playerVeh, 0)
    sendNuiMessage("updateStockNumber", {
        modId = 997,
        stock = IsToggleModOn(playerVeh, 22) and 1 or 0
    })
end

nuiCallbackRegisterNUICallback(NUI_EVENT_XENON_OPEN, handleXenonOpen)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_XENON = "changeVehicleXenon"

function handleChangeXenon(data)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            SetVehicleModKit(playerVeh, 0)
            SetVehicleLights(playerVeh, 2) -- Ensure headlights are on

            if tonumber(data.index) == 0 then -- Turn off xenon
                ToggleVehicleMod(playerVeh, 22, false)
                for i, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 997 then
                        table.remove(basketItems, i)
                        break
                    end
                end
                local foundInBasket = false
                for _, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 997 then
                        item.price = Config.MechanicUpgradeDefaultPrice[997].count[1].price
                        item.index = ""
                        item.label = Config.MechanicUpgradeDefaultPrice[997].label
                        foundInBasket = true
                        break
                    end
                end
                if not foundInBasket then
                    table.insert(basketItems, {
                        modId = 997,
                        price = Config.MechanicUpgradeDefaultPrice[997].count[1].price,
                        index = "",
                        label = Config.MechanicUpgradeDefaultPrice[997].label
                    })
                end
            else -- Turn on xenon
                ToggleVehicleMod(playerVeh, 22, true)
                for i, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 997 then
                        table.remove(basketItems, i)
                        break
                    end
                end
                local foundInBasket = false
                for _, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 997 then
                        item.price = Config.MechanicUpgradeDefaultPrice[997].count[2].price
                        item.index = ""
                        item.label = Config.MechanicUpgradeDefaultPrice[997].label
                        foundInBasket = true
                        break
                    end
                end
                if not foundInBasket then
                    table.insert(basketItems, {
                        modId = 997,
                        price = Config.MechanicUpgradeDefaultPrice[997].count[2].price,
                        index = "",
                        label = Config.MechanicUpgradeDefaultPrice[997].label
                    })
                end
            end
            sendNuiMessage("updateStockNumber", {
                modId = 997,
                stock = IsToggleModOn(playerVeh, 22) and 1 or 0
            })
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_XENON, handleChangeXenon)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_TURBO = "changeVehicleTurbo"

function handleChangeTurbo(data)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            SetVehicleModKit(playerVeh, 0)
            if tonumber(data.index) == 0 then -- Turn off turbo
                ToggleVehicleMod(playerVeh, 18, false)
                for i, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 18 then
                        table.remove(basketItems, i)
                        break
                    end
                end
            else -- Turn on turbo
                ToggleVehicleMod(playerVeh, 18, true)
                local foundInBasket = false
                for _, item in ipairs(basketItems) do
                    if tonumber(item.modId) == 18 then
                        item.price = Config.MechanicUpgradeDefaultPrice[18].count[2].price
                        item.index = ""
                        item.label = Config.MechanicUpgradeDefaultPrice[18].label
                        foundInBasket = true
                        break
                    end
                end
                if not foundInBasket then
                    table.insert(basketItems, {
                        modId = 18,
                        price = Config.MechanicUpgradeDefaultPrice[18].count[2].price,
                        index = "",
                        label = Config.MechanicUpgradeDefaultPrice[18].label
                    })
                end
            end
            updateVehicleCard()
            sendNuiMessage("updateStockNumber", {
                modId = 18,
                stock = IsToggleModOn(playerVeh, 18) and 1 or 0
            })
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_TURBO, handleChangeTurbo)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_PLATE_INDEX = "changeVehiclePlayer"

function handleChangePlateIndex(data)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            local foundInBasket = false
            for _, item in ipairs(basketItems) do
                if tonumber(item.modId) == 993 then
                    item.price = Config.MechanicUpgradeDefaultPrice[993].price
                    item.index = data.index
                    item.label = Config.MechanicUpgradeDefaultPrice[993].label
                    foundInBasket = true
                    break
                end
            end
            if not foundInBasket then
                table.insert(basketItems, {
                    modId = 993,
                    price = Config.MechanicUpgradeDefaultPrice[993].price,
                    index = data.index,
                    label = Config.MechanicUpgradeDefaultPrice[993].label
                })
            end
            SetVehicleNumberPlateTextIndex(playerVeh, data.index)
            sendNuiMessage("updateStockNumber", {
                modId = 993,
                stock = GetVehicleNumberPlateTextIndex(playerVeh)
            })
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_PLATE_INDEX, handleChangePlateIndex)

function listContains(list, value)
    for i = 1, #list, 1 do
        if list[i] == value then
            return true
        end
    end
    return false
end

nuiCallbackListContains = listContains

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_REPAIR_VEHICLE = "repairVehicle"

function handleRepairVehicle()
    repairVehicle(playerVeh)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_REPAIR_VEHICLE, handleRepairVehicle)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CLEAN_VEHICLE = "cleanVehicle"

function handleCleanVehicle()
    cleanVehicle(playerVeh)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CLEAN_VEHICLE, handleCleanVehicle)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHANGE_VEHICLE_MODIFICATION = "changeVehicleModification"

function handleChangeModification(data)
    if playerVeh ~= 0 then
        if DoesEntityExist(playerVeh) then
            local currentMod = GetVehicleMod(playerVeh, data.modId)
            if currentMod == data.index then
                SetVehicleMod(playerVeh, data.modId, -1)
                for i, item in ipairs(basketItems) do
                    if tonumber(item.modId) == tonumber(data.modId) then
                        table.remove(basketItems, i)
                        break
                    end
                end
            else
                SetVehicleMod(playerVeh, data.modId, data.index)
                local foundInBasket = false
                for _, item in ipairs(basketItems) do
                    if tonumber(item.modId) == tonumber(data.modId) then
                        item.price = data.price
                        item.index = data.index
                        item.label = Config.MechanicUpgradeDefaultPrice[tonumber(data.modId)].label
                        foundInBasket = true
                        break
                    end
                end
                if not foundInBasket then
                    table.insert(basketItems, {
                        modId = data.modId,
                        price = data.price,
                        index = data.index,
                        label = Config.MechanicUpgradeDefaultPrice[tonumber(data.modId)].label
                    })
                end
            end

            local modsToUpdateCard = {11, 13, 12, 15, 16, 18}
            if listContains(modsToUpdateCard, data.modId) then
                updateVehicleCard()
            end

            local vehicleProperties = GetVehicleProperties(playerVeh)
            local modConfig = Config.MechanicUpgradeDefaultPrice[tonumber(data.modId)]
            local stockValue = vehicleProperties[modConfig.modName]

            sendNuiMessage("updateStockNumber", {
                modId = data.modId,
                stock = stockValue
            })
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHANGE_VEHICLE_MODIFICATION, handleChangeModification)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SELECT_VEHICLE_WHEEL = "selectVehicleWheel"

function handleSelectVehicleWheel(data)
    SetVehicleModKit(playerVeh, 0)

    local function setWheelTypeAndCount(wheelTypeIndex, wheelTypeName)
        if "stock" == wheelTypeName then
            local wheelCount = 1
            sendNuiMessage("updateWheelCount", {
                wheelCount = wheelCount,
                wheelType = wheelTypeName
            })
            return
        end

        SetVehicleWheelType(playerVeh, wheelTypeIndex)
        local numMods = GetNumVehicleMods(playerVeh, 23)
        local wheelCount = 0
        for i = 0, numMods - 1 do
            wheelCount = wheelCount + 1
        end
        sendNuiMessage("updateWheelCount", {
            wheelCount = wheelCount,
            wheelType = wheelTypeName
        })
    end

    local wheelTypeMap = {
        sport = 0,
        muscle = 1,
        lowrider = 2,
        stock = 0, -- Stock is handled specially, but mapping 0 here as per original
        suv = 3,
        offroad = 4,
        tuner = 5,
        bike = 6,
        highend = 7
    }

    local wheelTypeIndex = wheelTypeMap[data.name]
    if wheelTypeIndex ~= nil then
        setWheelTypeAndCount(wheelTypeIndex, data.name)
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SELECT_VEHICLE_WHEEL, handleSelectVehicleWheel)

local vehicleExtras = {}
nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_GET_VEHICLE_EXTRA = "getVehicleExtra"

function handleGetVehicleExtra()
    vehicleExtras = {}
    SetVehicleModKit(playerVeh, 0)
    for i = 0, 14, 1 do
        if DoesExtraExist(playerVeh, i) then
            table.insert(vehicleExtras, {
                id = i,
                state = IsVehicleExtraTurnedOn(playerVeh, i)
            })
        end
    end
    sendNuiMessage("updateExtraCount", {
        extra = vehicleExtras
    })
end

nuiCallbackRegisterNUICallback(NUI_EVENT_GET_VEHICLE_EXTRA, handleGetVehicleExtra)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SET_VEHICLE_EXTRA = "setVehicleExtra"

function handleSetVehicleExtra(data)
    SetVehicleModKit(playerVeh, 0)
    local extraIndex = tonumber(data.id) + 1 -- NUI sends 0-indexed, Lua table is 1-indexed
    local extraData = vehicleExtras[extraIndex]

    if extraData then
        if IsVehicleExtraTurnedOn(playerVeh, extraData.id) then
            SetVehicleExtra(playerVeh, extraData.id, 1) -- Turn off extra
            for i, item in ipairs(basketItems) do
                if item.modId == "extra" .. extraData.id then
                    table.remove(basketItems, i)
                    break
                end
            end
            sendNuiMessage("updateVehicleBasket", basketItems)
            return
        else
            SetVehicleExtra(playerVeh, extraData.id, 0) -- Turn on extra
            local foundInBasket = false
            for _, item in ipairs(basketItems) do
                local modIdString = "extra" .. extraData.id
                if tonumber(item.modId) == modIdString then -- This comparison might be problematic if modId is string and item.modId is number
                    item.price = Config.MechanicUpgradeDefaultPrice[1000].price
                    item.index = extraData.id
                    item.label = Config.MechanicUpgradeDefaultPrice[1000].label
                    foundInBasket = true
                    break
                end
            end
            if not foundInBasket then
                table.insert(basketItems, {
                    modId = "extra" .. extraData.id,
                    price = Config.MechanicUpgradeDefaultPrice[1000].price,
                    index = extraData.id,
                    label = Config.MechanicUpgradeDefaultPrice[1000].label
                })
            end
            sendNuiMessage("updateVehicleBasket", basketItems)
        end
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SET_VEHICLE_EXTRA, handleSetVehicleExtra)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SET_VEHICLE_LIVERY = "setVehicleLivery"

function handleSetVehicleLivery(data)
    SetVehicleModKit(playerVeh, 0)
    local currentLivery = GetVehicleLivery(playerVeh)
    local liveryCount = GetVehicleLiveryCount(playerVeh)

    if currentLivery == data.id then -- Attempting to disable the current livery
        if liveryCount == -1 then -- Special case for vehicles with no liveries (mod 48)
            SetVehicleMod(playerVeh, 48, tonumber(-1))
            SetVehicleLivery(playerVeh, -1)
            local foundInBasket = false
            for _, item in ipairs(basketItems) do
                if tonumber(item.modId) == 48 then
                    item.price = Config.MechanicUpgradeDefaultPrice[48].removeprice
                    item.index = data.id
                    item.label = Config.MechanicUpgradeDefaultPrice[48].label
                    foundInBasket = true
                    break
                end
            end
            if not foundInBasket then
                table.insert(basketItems, {
                    modId = 48,
                    price = Config.MechanicUpgradeDefaultPrice[48].removeprice,
                    index = data.id,
                    label = Config.MechanicUpgradeDefaultPrice[48].label
                })
            end
            sendNuiMessage("updateStockNumber", {
                modId = 48,
                stock = -1
            })
        else
            SetVehicleLivery(playerVeh, 0) -- Set to default livery
            sendNuiMessage("updateStockNumber", {
                modId = 48,
                stock = 0
            })
        end
    else -- Setting a new livery
        if liveryCount == -1 then -- Special case for vehicles with no liveries
            SetVehicleMod(playerVeh, 48, tonumber(data.id))
            SetVehicleLivery(playerVeh, tonumber(data.id))
        else
            SetVehicleLivery(playerVeh, tonumber(data.id))
        end

        local foundInBasket = false
        for _, item in ipairs(basketItems) do
            if tonumber(item.modId) == 48 then
                item.price = Config.MechanicUpgradeDefaultPrice[48].price
                item.index = data.id
                item.label = Config.MechanicUpgradeDefaultPrice[48].label
                foundInBasket = true
                break
            end
        end
        if not foundInBasket then
            table.insert(basketItems, {
                modId = 48,
                price = Config.MechanicUpgradeDefaultPrice[48].price,
                index = data.id,
                label = Config.MechanicUpgradeDefaultPrice[48].label
            })
        end
        sendNuiMessage("updateStockNumber", {
            modId = 48,
            stock = data.id
        })
    end
    sendNuiMessage("updateVehicleBasket", basketItems)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SET_VEHICLE_LIVERY, handleSetVehicleLivery)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_SET_VEHICLE_WHEEL_CHANGE = "setVehicleWheelChange"

function handleSetVehicleWheelChange(data)
    local currentWheelType = GetVehicleWheelType(playerVeh)
    local currentWheelIndex = GetVehicleMod(playerVeh, 23)
    SetVehicleModKit(playerVeh, 0)

    local wheelId = data.wheelId or 0
    local wheelIndex = data.index or -1

    SetVehicleWheelType(playerVeh, wheelId)
    SetVehicleMod(playerVeh, 23, wheelIndex, false)

    local wheelTypeNames = {
        [0] = "sport",
        [1] = "muscle",
        [2] = "lowrider",
        [3] = "suv",
        [4] = "offroad",
        [5] = "tuner",
        [6] = "bike",
        [7] = "highend"
    }

    local isWheelModTable = {}
    for k, v in pairs(wheelTypeNames) do
        isWheelModTable[v] = true
    end

    for i = #basketItems, 1, -1 do
        local item = basketItems[i]
        if isWheelModTable[item.modId] then
            table.remove(basketItems, i)
            break
        end
    end

    local foundInBasket = false
    for _, item in ipairs(basketItems) do
        local newModId = wheelTypeNames[wheelId]
        if item.modId == newModId then
            item.price = Config.MechanicUpgradeDefaultPrice[newModId].price
            item.index = ""
            item.label = Config.MechanicUpgradeDefaultPrice[newModId].label
            foundInBasket = true
            break
        end
    end
    if not foundInBasket then
        local newModId = wheelTypeNames[wheelId]
        table.insert(basketItems, {
            modId = newModId,
            price = Config.MechanicUpgradeDefaultPrice[newModId].price,
            index = "",
            label = Config.MechanicUpgradeDefaultPrice[newModId].label
        })
    end
    sendNuiMessage("updateVehicleBasket", basketItems)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_SET_VEHICLE_WHEEL_CHANGE, handleSetVehicleWheelChange)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_OPEN_VEHICLE_NEON = "openVehicleNeon"

function handleOpenVehicleNeon(state)
    if state then
        SetVehicleNeonLightEnabled(playerVeh, 0, true)
        SetVehicleNeonLightEnabled(playerVeh, 1, true)
        SetVehicleNeonLightEnabled(playerVeh, 2, true)
        SetVehicleNeonLightEnabled(playerVeh, 3, true)

        local colors = table.pack(GetVehicleNeonLightsColour(playerVeh))
        if tonumber(colors[1]) == 255 and tonumber(colors[2]) == 255 and tonumber(colors[3]) == 255 then
            sendNuiMessage("updateStockNumber", {
                modId = 996,
                stock = 0
            })
        else
            sendNuiMessage("updateStockNumber", {
                modId = 996,
                stock = 1
            })
        end
    else
        SetVehicleNeonLightEnabled(playerVeh, 0, false)
        SetVehicleNeonLightEnabled(playerVeh, 1, false)
        SetVehicleNeonLightEnabled(playerVeh, 2, false)
        SetVehicleNeonLightEnabled(playerVeh, 3, false)
    end
end

nuiCallbackRegisterNUICallback(NUI_EVENT_OPEN_VEHICLE_NEON, handleOpenVehicleNeon)

local freecam = false
nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_FREECAM = "freecam"

function handleFreecam()
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(mainCam, true)
    DestroyCam(frontCam, true)
    DestroyCam(rearCam, true)
    DestroyCam(leftCam, true)
    DestroyCam(rightCam, true)
    DestroyCam(topCam, true)
    DestroyCam(interiorCam, true)
    DestroyCam(wheelCam, true)
    DestroyCam(wheelsteringCam, true)
    FreezeEntityPosition(playerVeh, true)
    ClearFocus()
    sendNuiMessage("openFreeCam")
    freecam = true
    CreateThread(function()
        while freecam do
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Look L/R
            EnableControlAction(0, 2, true) -- Look U/D
            EnableControlAction(0, 38, true) -- E
            EnableControlAction(0, 86, true) -- INPUT_VEH_HORN
            EnableControlAction(0, 249, true) -- INPUT_MP_TEXT_CHAT_ALL
            Wait(1)
            if IsControlJustPressed(0, 38) then
                freecam = false
                openMenu("mechanic", lastMenuLabel)
            end
        end
    end)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_FREECAM, handleFreecam)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_OPEN_MOUSE = "openMouse"

function handleOpenMouse()
    SetNuiFocus(true, true)
    CreateCamVehicle()
end

nuiCallbackRegisterNUICallback(NUI_EVENT_OPEN_MOUSE, handleOpenMouse)

nuiCallbackAddEventHandler = AddEventHandler
local EVENT_ON_RESOURCE_STOP = "onResourceStop"

function handleResourceStop(resourceName)
    if GetCurrentServerEndpoint() == nil then
        return
    end

    if resourceName == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(mainCam, true)
        DestroyCam(frontCam, true)
        DestroyCam(rearCam, true)
        DestroyCam(leftCam, true)
        DestroyCam(rightCam, true)
        DestroyCam(topCam, true)
        DestroyCam(interiorCam, true)
        DestroyCam(wheelCam, true)
        DestroyCam(DireksiyonCam, true) -- Assuming DireksiyonCam is a global cam object
        ClearFocus()
        SetVehicleBurnout(playerVeh, false)
        FreezeEntityPosition(playerVeh, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

nuiCallbackAddEventHandler(EVENT_ON_RESOURCE_STOP, handleResourceStop)

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CLOSE = "close"

function handleClose()
    openMenuDrawText = false
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(mainCam, true)
    DestroyCam(frontCam, true)
    DestroyCam(rearCam, true)
    DestroyCam(leftCam, true)
    DestroyCam(rightCam, true)
    DestroyCam(topCam, true)
    DestroyCam(interiorCam, true)
    DestroyCam(wheelCam, true)
    ClearFocus()
    FreezeEntityPosition(playerVeh, false)
    SetVehicleBurnout(playerVeh, false)

    for i = 0, 7, 1 do
        if GetVehicleDoorAngleRatio(playerVeh, i) > 0 then
            SetVehicleDoorShut(playerVeh, i, false)
        end
    end

    basketItems = {}

    if not isVehicleCompleted then
        SetVehicleProperties(playerVeh, oldDataVehicle)
    end
    SetVehicleLights(playerVeh, 0)

    isVehicleCompleted = false
    playerVeh = nil
    freecam = false
    hideMenuClose()
    oldDataVehicle = false
    lastMenuLabel = false
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CLOSE, handleClose)

function getNearbyPlayers(coords, radius)
    local activePlayers = GetActivePlayers()
    local playerPed = PlayerPedId()

    if coords then
        local vec3Coords = vec3(coords.x, coords.y, coords.z)
        coords = vec3Coords or coords
        if not vec3Coords then
        end
    else
        coords = GetEntityCoords(playerPed)
    end

    if not radius then
        radius = 5
    end

    local nearbyPlayers = {}
    for _, playerId in pairs(activePlayers) do
        local ped = GetPlayerPed(playerId)
        local pedCoords = GetEntityCoords(ped)
        local distance = #(pedCoords - coords)
        if radius >= distance then
            table.insert(nearbyPlayers, playerId)
        end
    end
    return nearbyPlayers
end

nuiCallbackGetNearbyPlayers = getNearbyPlayers

nuiCallbackRegisterNUICallback = RegisterNUICallback
local NUI_EVENT_CHECK_NEARBY_PLAYERS = "checkNearbyPlayers"

function handleCheckNearbyPlayers(data)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyPlayers = getNearbyPlayers(playerCoords, 5)

    local playerIdsToSend = {}
    for _, playerId in ipairs(nearbyPlayers) do
        table.insert(playerIdsToSend, {
            id = GetPlayerServerId(playerId)
        })
    end
    TriggerServerEvent("codem-mechanic:getNearbyPlayers", playerIdsToSend)
end

nuiCallbackRegisterNUICallback(NUI_EVENT_CHECK_NEARBY_PLAYERS, handleCheckNearbyPlayers)

nuiCallbackRegisterNUICallback = RegisterNetEvent
local NET_EVENT_SET_NEARBY_PLAYERS = "codem-mechanic:setNearbyPlayers"

function handleSetNearbyPlayers(playersData)
    if playersData then
        sendNuiMessage("updateNearbyPlayers", playersData)
    end
end

nuiCallbackRegisterNUICallback(NET_EVENT_SET_NEARBY_PLAYERS, handleSetNearbyPlayers)

function jobSuccesMoney(amount)
    TriggerServerEvent("codem-mechanic:giveMoney", key, tonumber(amount))
end

nuiCallbackJobSuccesMoney = jobSuccesMoney