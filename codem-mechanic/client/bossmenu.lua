Core = nil
job = ''
job_grade_level = 0
job_grade_name = ''
local ranks = {}
local employees = {}
local logs = {}

local bossInventory = {}
bossMenuOpen = false

function UpdateLogs()
    local data = TriggerCallback('codem-mechanic:GetLogs')
    logs = data
    NuiMessage('UPDATE_LOGS', data)
end

RegisterNetEvent("codem-mechanic:UpdateLogs")
AddEventHandler("codem-mechanic:UpdateLogs", UpdateLogs)

RegisterNetEvent("codem-mechanic:NewLog")
AddEventHandler("codem-mechanic:NewLog", function(data)
    table.insert(logs, data)
    NuiMessage('UPDATE_LOGS', logs)
end)

-- RegisterNetEvent("codem-inventory:SetClientInventory")
-- AddEventHandler("codem-inventory:SetClientInventory", function()
--     if bossMenuOpen then
--         local inventory = TriggerCallback('codem-mechanic:GetPlayerInventory')
--         NuiMessage('SetInventory', inventory)
--     end
-- end)


-- RegisterNetEvent("esx:addInventoryItem")
-- AddEventHandler("esx:addInventoryItem", function()
--     if bossMenuOpen then
--         local inventory = TriggerCallback('codem-mechanic:GetPlayerInventory')
--         NuiMessage('SetInventory', inventory)
--     end
-- end)

function SetMyRank()
    local myRankData = false
    for _, v in pairs(ranks) do
        if tonumber(v.grade) == tonumber(job_grade_level) then
            myRankData = v
        end
    end
    if myRankData then
        NuiMessage('SET_MY_RANK', myRankData)
    end
end

function CheckPermission(name)
    if not ranks or next(ranks) == nil then
        local _ranks = TriggerCallback('codem-mechanic:GetJobRanks')
        ranks = _ranks
    end
    local myRankData = false
    for _, v in pairs(ranks) do
        if tonumber(v.grade) == tonumber(job_grade_level) then
            myRankData = v
        end
    end
    if myRankData and (myRankData.permissions[name] or myRankData.isBoss) then
        return true
    end

    return false
end

RegisterNUICallback("WithdrawMoney", function(data, cb)
    local amount = data.amount
    TriggerServerEvent("codem-mechanic:WithdrawMoney", amount)
    cb("ok")
end)


RegisterNUICallback("DepositMoney", function(data, cb)
    local amount = data.amount
    TriggerServerEvent("codem-mechanic:DepositMoney", amount)
    cb("ok")
end)

RegisterNetEvent("codem-mechanic:RefreshBossMoney")
AddEventHandler("codem-mechanic:RefreshBossMoney", function()
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        if Config.ModifyWithYourCash then
            local playerMoney = TriggerCallback('codem-mechanic:getPlayerAccount')
            TriggerEvent("codem-mechanic:RefreshMechanicVault", playerMoney)
            NuiMessage('SET_BOSS_MONEY', playerMoney)
            return
        end
        local money = TriggerCallback('codem-mechanic:GetBossMoney')
        NuiMessage('SET_BOSS_MONEY', money)
        TriggerEvent("codem-mechanic:RefreshMechanicVault", money)
    end
    if (openMenuDrawText and Config.MechanicMode == 'no_job') or (openMenuDrawText and CheckCanUseMechanic(getNearestMechanic()) ) then
        Wait(1000)
        local mechanic = Config.MechanicSettings[job]
        if mechanic then
            if Config.ModifyWithYourCash then
                local playerMoney = TriggerCallback('codem-mechanic:getPlayerAccount')
                TriggerEvent("codem-mechanic:RefreshMechanicVault", playerMoney)
                NuiMessage('SET_BOSS_MONEY', playerMoney)
                return
            end
            local money = TriggerCallback('codem-mechanic:GetBossMoney')
            NuiMessage('SET_BOSS_MONEY', money)
            TriggerEvent("codem-mechanic:RefreshMechanicVault", money)
        else
            local profileAccount = TriggerCallback('codem-mechanic:getAccount')
            TriggerEvent("codem-mechanic:RefreshMechanicVault", profileAccount.cash)
        end


    end
end)

RegisterNetEvent("codem-mechanic:UpdateInv")
AddEventHandler("codem-mechanic:UpdateInv", function(inventory)
    if bossMenuOpen then
        NuiMessage('SetInventory', FormatItems(inventory))
    end
end)

function FormatItems(items)
    local data = {}
    for _, v in pairs(items) do
        local amount = v.count or v.amount
        local formattedData = v
        formattedData.name = v.name
        formattedData.label = v.label
        formattedData.amount = amount
        formattedData.metadata = v.metadata or v.info
        table.insert(data, formattedData)
    end
    return data
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    Wait(1000)
    SetPlayerJob()
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    SetPlayerJob()
end)

-- RegisterNetEvent("QBCore:Player:SetPlayerData")
-- AddEventHandler("QBCore:Player:SetPlayerData", function(PlayerData)
--     if bossMenuOpen then
--         NuiMessage('SetInventory', FormatItems(PlayerData.items))
--     end
-- end)

-- RegisterNetEvent("esx:removeInventoryItem")
-- AddEventHandler("esx:removeInventoryItem", function()
--     if bossMenuOpen then
--         local inventory = TriggerCallback('codem-mechanic:GetPlayerInventory')
--         NuiMessage('SetInventory', inventory)
--     end
-- end)

RegisterNetEvent("codem-mechanic:BossInventoryItemAdded")
AddEventHandler("codem-mechanic:BossInventoryItemAdded", function(data)
    table.insert(bossInventory, data)
    NuiMessage("UPDATE_BOSS_INVENTORY", bossInventory)
end)

RegisterNetEvent("codem-mechanic:BossInventoryItemRemoved")
AddEventHandler("codem-mechanic:BossInventoryItemRemoved", function(data)
    local item, index = GetBossItemByName(data.name, data.metadata)
    if item then
        table.remove(bossInventory, index)
        NuiMessage("UPDATE_BOSS_INVENTORY", bossInventory)
    end
end)


function TableComp(a,b) --algorithm is O(n log n), due to table growth.
    if #a ~= #b then return false end -- early out
    local t1,t2 = {}, {} -- temp tables
    for k,v in pairs(a) do -- copy all values into keys for constant time lookups
        t1[k] = (t1[k] or 0) + 1 -- make sure we track how many times we see each value.
    end
    for k,v in pairs(b) do
        t2[k] = (t2[k] or 0) + 1
    end
    for k,v in pairs(t1) do -- go over every element
        if v ~= t2[k] then return false end -- if the number of times that element was seen don't match...
    end
    return true
end


function GetBossItemByName(itemName, metadata)
    for _, v in pairs(bossInventory) do
        if metadata and v.metadata then
            if v.name == itemName and TableComp(v.metadata,metadata) then
                return v, _
            end
        else
            if v.name == itemName then
                return v, _
            end
        end
    end
    return false
end

RegisterNetEvent("codem-mechanic:BossInventoryItemUpdated")
AddEventHandler("codem-mechanic:BossInventoryItemUpdated", function(data)
    local item, index = GetBossItemByName(data.name)
    if item then
        bossInventory[index] = data
        NuiMessage("UPDATE_BOSS_INVENTORY", bossInventory)
    end
end)

RegisterNetEvent("codem-mechanic:NewEmployee")
AddEventHandler("codem-mechanic:NewEmployee", function(data)
    table.insert(employees, data)
    NuiMessage("SET_EMPLOYEES", employees)
    UpdateRanks()
end)

RegisterNetEvent("codem-mechanic:UpdateEmployee")
AddEventHandler("codem-mechanic:UpdateEmployee", function(identifier, data)
    for _, v in pairs(employees) do
        if v.identifier == identifier then
            employees[_] = data
        end
    end
    NuiMessage("SET_EMPLOYEES", employees)
    UpdateRanks()
end)

RegisterNUICallback("HireNewPlayer", function(data, cb)
    local id = data.id
    TriggerServerEvent("codem-mechanic:HireNewPlayer", id)
end)

RegisterNUICallback("PromotePlayer", function(data, cb)
    local identifier = data.identifier
    TriggerServerEvent("codem-mechanic:PromotePlayer", identifier)
end)

RegisterNUICallback("DemotePlayer", function(data, cb)
    local identifier = data.identifier
    TriggerServerEvent("codem-mechanic:DemotePlayer", identifier)
end)

RegisterNUICallback("FirePlayer", function(data, cb)
    local identifier = data.identifier
    TriggerServerEvent("codem-mechanic:FirePlayer", identifier)
end)

RegisterNetEvent("codem-mechanic:RemoveEmployee")
AddEventHandler("codem-mechanic:RemoveEmployee", function(identifier)
    for _, v in pairs(employees) do
        if v.identifier == identifier then
            table.remove(employees, _)
        end
    end
    NuiMessage("SET_EMPLOYEES", employees)
    UpdateRanks()
end)

function UpdateRanks()
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        local _ranks = TriggerCallback('codem-mechanic:GetJobRanks')
        ranks = _ranks
        NuiMessage("SET_RANKS", ranks)
        SetMyRank()
    end
end

function UpdateEmployees()
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        local _employees = TriggerCallback('codem-mechanic:GetEmployees')
        employees = _employees
        NuiMessage("SET_EMPLOYEES", employees)
    end
end

function UpdateBossInventory()
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        local inventory = TriggerCallback('codem-mechanic:GetBossInventory', job)
        bossInventory = inventory
        NuiMessage("UPDATE_BOSS_INVENTORY", bossInventory)
    end
end

function TriggerCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    while Core == nil do
        Wait(0)
    end
    if Config.Framework == 'esx' then
        Core.TriggerServerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    else
        Core.Functions.TriggerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    end
    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Wait(0)
    end
    return incomingData
end

function WaitPlayer()
    if Config.Framework == "esx" or Config.Framework == 'oldesx' then
        while Core == nil do
            Wait(0)
        end
        while Core.GetPlayerData() == nil do
            Wait(0)
        end
        while Core.GetPlayerData().job == nil do
            Wait(0)
        end
    else
        while Core == nil do
            Wait(0)
        end
        while Core.Functions.GetPlayerData() == nil do
            Wait(0)
        end
        while Core.Functions.GetPlayerData().metadata == nil do
            Wait(0)
        end
    end
end

CreateThread(function()
    Core, Config.Framework = GetCore()
    SetPlayerJob()
    for k, v in pairs(Config.MechanicSettings) do
        if v.blipSettings.showBlip then
            local blip = AddBlipForCoord(v.blipSettings.coords)
            SetBlipSprite(blip, v.blipSettings.sprite)
            SetBlipScale(blip, v.blipSettings.scale)
            SetBlipColour(blip, v.blipSettings.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.blipSettings.label)
            EndTextCommandSetBlipName(blip)


          
        end
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    Wait(1000)
    SetPlayerJob()
end)


RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
    Wait(1000)
    SetPlayerJob()
end)

function SetPlayerJob()
    Wait(500)
    while not nuiLoaded do
        Wait(50)
    end
    WaitPlayer()
    CheckJob()

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local PlayerData = Core.GetPlayerData()
        job = PlayerData.job.name
        job_grade_level = PlayerData.job.grade
        job_grade_name = PlayerData.job.grade_label
    else
        local PlayerData = Core.Functions.GetPlayerData()
        job = PlayerData["job"].name

        job_grade_level = PlayerData["job"].grade.level
        job_grade_name = PlayerData["job"].grade.name
    end

    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        TriggerServerEvent("codem-mechanic:CreateMechanicData")
        if Config.MechanicMode == 'only_job' or CheckCanUseMechanic(job) then
            if Config.InteractionHandler == 'ox-target' then
                for _, v in pairs(mechanic.bossMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZone", v, 'mechanic-boss', {
                        {
                            name = 'mechanic-boss',
                            event = 'codem-mechanic:OpenBossMenu',
                            icon = 'fa-solid fa-bars-progress',
                            label = Config.Locales.OPEN_BOSS_MENU,
                        }
                    })
                end
                for _, v in pairs(mechanic.mechanicMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZone", v, 'mechanic-tuning-menu', {
                        {
                            name = 'mechanic-boss',
                            event = 'codem-mechanic:OpenMechanicMenu',
                            icon = 'fas fa-gears',
                            label = Config.Locales.OPEN_MECHANIC_MENU,
                        }
                    })
                end
            end
            if Config.InteractionHandler == 'qb-target' then
                for _, v in pairs(mechanic.bossMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZone", v, mechanic)
                end
                for _, v in pairs(mechanic.mechanicMenuCoords) do
                    TriggerEvent("codem-mechanic:AddZoneMechanic", v, mechanic)
                end
            end
        end
        Wait(1000)
        UpdateBossInventory()
        UpdateEmployees()
        UpdateRanks()
        SetMyRank()
        UpdateLogs()
        TriggerEvent("codem-mechanic:RefreshBossMoney")
    else
        if Config.InteractionHandler == 'ox-target' then
            TriggerEvent("codem-mechanic:RemoveZone", 'mechanic-boss')
            TriggerEvent("codem-mechanic:RemoveZone", 'mechanic-tuning-menu')
        end
        if Config.InteractionHandler == 'qb-target' then
            TriggerEvent("codem-mechanic:RemoveZone")
            TriggerEvent("codem-mechanic:RemoveZone")
        end
    end
end

RegisterNUICallback("ChangePermission", function(data, cb)
    local rankLevel = data.rankLevel
    local permissionName = data.permissionName
    local allow = data.allow
    TriggerServerEvent("codem-mechanic:ChangePermission", rankLevel, permissionName, allow)
end)

RegisterNetEvent("codem-mechanic:UpdateRanks")
AddEventHandler("codem-mechanic:UpdateRanks", function()
    UpdateRanks()
end)

function CheckJob()
    WaitPlayer()
    local currentJob
    local currentJobGradeLevel
    local currentJobGradeLabel
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local PlayerData = Core.GetPlayerData()
        currentJob = PlayerData.job.name
        currentJobGradeLevel = PlayerData.job.grade
        currentJobGradeLabel = PlayerData.job.grade_label
    else
        local PlayerData = Core.Functions.GetPlayerData()
        currentJob = PlayerData["job"].name
        currentJobGradeLevel = PlayerData["job"].grade.level
        currentJobGradeLabel = PlayerData["job"].grade.name
    end
    local lastJob = job
    local lastJobGradeLevel = job_grade_level
    local _mechanic = Config.MechanicSettings[lastJob]
    local mechanic = Config.MechanicSettings[currentJob]
    if lastJob ~= currentJob and _mechanic then
        TriggerServerEvent("codem-mechanic:RemoveEmployee", {
            name = lastJob,
        })
    end

    if mechanic then
        TriggerServerEvent("codem-mechanic:AddEmployee", {
            name = currentJob,
            grade_level = currentJobGradeLevel,
            grade_name = currentJobGradeLabel,
        })
        Wait(500)
        TriggerServerEvent("codem-mechanic:UpdateEmployee", {
            name = currentJob,
        }, "online", true)
    end
    if lastJob == currentJob and lastJobGradeLevel ~= currentJobGradeLevel and mechanic then
        TriggerServerEvent("codem-mechanic:UpdateEmployee", {
            name = currentJob,
        }, "grade_level", currentJobGradeLevel)
        TriggerServerEvent("codem-mechanic:UpdateEmployee", {
            name = currentJob,
        }, "grade_name", currentJobGradeLabel)
    end
end

RegisterNUICallback("DragItem", function(data, cb)
    TriggerServerEvent("codem-mechanic:DragItem", data)
    cb("ok")
end)