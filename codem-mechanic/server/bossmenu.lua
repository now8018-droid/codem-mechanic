Core = nil
local mechanics = {}
local logs = {}

CreateThread(function()
    local result = ExecuteSql("SELECT * FROM `codem_mechanic_boss`")
    local _logs = ExecuteSql("SELECT * FROM `codem_mechanic_logs`")
    logs = _logs
    for _, v in pairs(result) do
        v.inventory = json.decode(v.inventory)
        v.employees = json.decode(v.employees)
        v.permissions = json.decode(v.permissions)
        v.logs = GetMechanicLogs(v.name)
    end
    mechanics = result
end)

CreateThread(function()
    Core, Config.Framework = GetCore()
end)

function GetMechanicLogs(name)
    local data = {}
    for _, v in pairs(logs) do
        if v.name == name then
            table.insert(data, v)
        end
    end
    return data
end

RegisterNetEvent("codem-mechanic:AddLog")
AddEventHandler("codem-mechanic:AddLog", function(name, message)
    AddLog(name, message)
end)

function AddLog(name, message)
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        local time = os.time()
        local data = {
            name = name,
            message = message,
            date = time
        }
        ExecuteSql("INSERT INTO `codem_mechanic_logs` (`name`, `message`,  `date`) VALUES ('" ..
            name .. "', '" .. message .. "',  '" .. time .. "')")
        if not mechanic.logs then
            mechanic.logs = {}
        end
        table.insert(mechanic.logs, data)
        local players = GetOnlineMechanicEmployees(name)
        for _, v in pairs(players) do
            TriggerClientEvent("codem-mechanic:NewLog", v, data)
        end
    end
end

function ExecuteSql(query, parameters)
    local IsBusy = true
    local result = nil
    if Config.SQL == "oxmysql" then
        if parameters then
            exports.oxmysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.SQL == "ghmattimysql" then
        if parameters then
            exports.ghmattimysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.ghmattimysql:execute(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.SQL == "mysql-async" then
        if parameters then
            MySQL.Async.fetchAll(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.Async.fetchAll(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

function RegisterCallback(name, cbFunc)
    while not Core do
        Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Core.RegisterServerCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    else
        Core.Functions.CreateCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    end
end

function GetJobRanks(source)
    local job = GetJob(source)
    local mechanic = GetMechanicDataByName(job)
    local data = {}
    if mechanic then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            while not next(Core.Jobs) do
                Wait(500)
                Core.Jobs = Core.GetJobs()
            end
            if Core.Jobs[job] then
                for _, v in pairs(Core.Jobs[job].grades) do
                    table.insert(data, {
                        label = v.label,
                        playerCount = GetPlayerCountInGrade(job, v.grade),
                        grade = v.grade,
                        isBoss = (Config.MechanicSettings[job].bossGradeLevel == v.grade) and true or false,
                        permissions = mechanic.permissions[tostring(v.grade)] or {}
                    })
                end
            end
        else
            if Core.Shared.Jobs[job] then
                for gradeLevel, v in pairs(Core.Shared.Jobs[job].grades) do
                    table.insert(data, {
                        label = v.name,
                        playerCount = GetPlayerCountInGrade(job, tonumber(gradeLevel)),
                        grade = tonumber(gradeLevel),
                        isBoss = (tonumber(Config.MechanicSettings[job].bossGradeLevel) == tonumber(gradeLevel)) and true or
                            false,
                        permissions = mechanic.permissions[tostring(gradeLevel)] or {}
                    })
                end
            end
        end
    end
    return data
end

function GetPlayerCountInGrade(job, gradeLevel)
    local count = 0
    local mechanic = GetMechanicDataByName(job)
    for _, v in pairs(mechanic.employees) do
        if tonumber(v.grade_level) == tonumber(gradeLevel) then
            count = count + 1
        end
    end
    return count
end

function GetPlayer(source)
    local Player = false
    while Core == nil do
        Citizen.Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromId(source)
    else
        Player = Core.Functions.GetPlayer(source)
    end
    return Player
end

function GetPlayerFromIdentifier(identifier)
    local Player = false
    while Core == nil do
        Citizen.Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromIdentifier(identifier)
    else
        Player = Core.Functions.GetPlayerByCitizenId(identifier)
    end
    return Player
end

function GetIdentifier(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return Player.getIdentifier()
        else
            return Player.PlayerData.citizenid
        end
    end
end

function GetJob(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return Player.getJob().name, Player.getJob().grade
        else
            return Player.PlayerData.job.name, Player.PlayerData.job.grade.level
        end
    end
    return false
end

function GetName(source)
    if Config.Framework == "oldesx" or Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local Player = Core.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    elseif Config.Framework == 'standalone' then
        return GetPlayerName(source)
    end
end

function CheckBlacklistItem(item)
    for _, v in pairs(Config.BlacklistedItems) do
        if v == item then
            return true
        end
    end
    return false
end

function GetPlayerInventory(source)
    local data = {}
    local Player = GetPlayer(source)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        for _, v in pairs(Player.getInventory()) do
            local count = v.count or v.amount
            if v and tonumber(count) > 0 and not CheckBlacklistItem(v.name) then
                local formattedData = v
                formattedData.name = v.name
                formattedData.label = v.label
                formattedData.amount = count
                formattedData.image = v.image or (v.name .. '.png')

                local metadata = v.metadata or v.info
                if not metadata or next(metadata) == nil then
                    metadata = false
                end
                formattedData.metadata = metadata

                table.insert(data, formattedData)
            end
        end
    else
        for _, v in pairs(Player.PlayerData.items) do
            if v then
                local amount = v.count or v.amount
                if tonumber(amount) > 0 and not CheckBlacklistItem(v.name) then
                    local formattedData = v
                    formattedData.name = v.name
                    formattedData.label = v.label
                    formattedData.amount = amount
                    formattedData.image = v.image or (v.name .. '.png')
                    local metadata = v.metadata or v.info
                    if not metadata or next(metadata) == nil then
                        metadata = false
                    end
                    formattedData.metadata = metadata
                    table.insert(data, formattedData)
                end
            end
        end
    end
    return data
end

function CreateMechanicData(name)
    for _, v in pairs(mechanics) do
        if v.name == name then
            return
        end
    end
    local data = {
        name = name,
        inventory = {},
        money = 0,
        employees = {},
        permissions = {},
    }
    table.insert(mechanics, data)
    ExecuteSql("INSERT INTO `codem_mechanic_boss` (`name`, `inventory`,  `employees`, `permissions`) VALUES ('" ..
        name .. "', '" .. json.encode({}) .. "',  '" .. json.encode({}) .. "', '" .. json.encode({}) .. "')")
end

function GetMechanicDataByName(name)
    if not name then
        return false
    end
    if not mechanics then
        Wait(1000)
        if mechanics then
            for _, v in pairs(mechanics) do
                if v.name == name then
                    return v
                end
            end
        end
    end
    for _, v in pairs(mechanics) do
        if v.name == name then
            return v
        end
    end
end

function GetMechanicEmployeeByIdentifier(name, identifier)
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        for _, v in pairs(mechanic.employees) do
            if v.identifier == identifier then
                return v
            end
        end
    end
    return false
end

function IncreaseEmployeeBills(source)
    local job = GetJob(source)
    local employee = GetMechanicEmployeeByIdentifier(job, GetIdentifier(source))
    if employee then
        UpdateEmployee(source, {
            name = job
        }, "bills", tonumber(employee.bills) + 1)
    end
end

function UpdateEmployeeProfits(source, value)
    local job = GetJob(source)
    local employee = GetMechanicEmployeeByIdentifier(job, GetIdentifier(source))
    if employee then
        UpdateEmployee(source, {
            name = job
        }, "profit", tonumber(employee.profit) + tonumber(value))
    end
end

function AddEmployee(id, job)
    local Player = GetPlayer(id)
    local mechanic = GetMechanicDataByName(job.name)
    Wait(500)
    if not mechanic then
        CreateMechanicData(job.name)
        mechanic = GetMechanicDataByName(job.name)
    end
    if Player and mechanic then
        local employee = GetMechanicEmployeeByIdentifier(job.name, GetIdentifier(id))
        if employee then
            return
        end

        local avatar = "https://cdn.discordapp.com/attachments/983471660684423240/1147567519712940044/example-pp.png"
        if type(GetDiscordAvatar) == "function" then
            avatar = GetDiscordAvatar(id) or avatar
        end

        local data = {
            name = GetName(id),
            pp = avatar,
            bills = 0,
            profit = 0,
            online = true,
            grade_level = job.grade_level,
            grade_name = job.grade_name,
            joined_at = os.time(),
            identifier = GetIdentifier(id),
        }
        table.insert(mechanic.employees, data)
        ExecuteSql("UPDATE `codem_mechanic_boss` SET `employees` = '" ..
            json.encode(mechanic.employees) .. "' WHERE name = '" .. job.name .. "'")
        local players = GetOnlineMechanicEmployees(job.name)
        for _, v in pairs(players) do
            TriggerClientEvent("codem-mechanic:NewEmployee", v, data)
        end
    end
end

function RemoveEmployee(id, job)
    local Player = GetPlayer(id)
    local mechanic = GetMechanicDataByName(job.name)

    if Player and mechanic then
        local update = false
        for _, v in pairs(mechanic.employees) do
            if v.identifier == GetIdentifier(id) then
                update = true
                table.remove(mechanic.employees, _)
            end
        end
        if update then
            ExecuteSql("UPDATE `codem_mechanic_boss` SET `employees` = '" ..
                json.encode(mechanic.employees) .. "' WHERE name = '" .. job.name .. "'")
            local players = GetOnlineMechanicEmployees(job.name)
            for _, v in pairs(players) do
                TriggerClientEvent("codem-mechanic:RemoveEmployee", v, GetIdentifier(id))
            end
        end
    end
end

modifiyingPlayers = {}
RegisterServerEvent('codem-mechanic:server:StartModity', function(playerVeh, oldDataVehicle)
    local src = source
    modifiyingPlayers[src] = {
        data = oldDataVehicle,
        playerVeh = playerVeh
    }
end)

RegisterNetEvent('codem-mechanic:server:EndModify', function(source)
    modifiyingPlayers[source] = nil
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if modifiyingPlayers[src] then
        TriggerClientEvent('codem-mechanic:client:ForceDefaultVehicle', -1, modifiyingPlayers[src].playerVeh,
            modifiyingPlayers[src].data)
    end

    local job = GetJob(src)
    local employee = GetMechanicEmployeeByIdentifier(job, GetIdentifier(src))
    if employee then
        employee.online = false
        local mechanic = GetMechanicDataByName(job)
        ExecuteSql("UPDATE `codem_mechanic_boss` SET `employees` = '" ..
            json.encode(mechanic.employees) .. "' WHERE name = '" .. job .. "'")
    end
    modifiyingPlayers[src] = nil
end)


function UpdateEmployee(id, job, key, val)
    local Player = GetPlayer(id)
    local mechanic = GetMechanicDataByName(job.name)
    if Player and mechanic then
        for _, v in pairs(mechanic.employees) do
            if v.identifier == GetIdentifier(id) and mechanic.employees[_][key] ~= val then
                mechanic.employees[_][key] = val
                ExecuteSql("UPDATE `codem_mechanic_boss` SET `employees` = '" ..
                    json.encode(mechanic.employees) .. "' WHERE name = '" .. job.name .. "'")
                local players = GetOnlineMechanicEmployees(job.name)
                for __, vv in pairs(players) do
                    TriggerClientEvent("codem-mechanic:UpdateEmployee", vv, GetIdentifier(id), mechanic.employees[_])
                end
            end
        end
    end
end

RegisterServerEvent("codem-mechanic:AddEmployee")
AddEventHandler("codem-mechanic:AddEmployee", function(job)
    local src = source
    AddEmployee(src, job)
end)

RegisterServerEvent("codem-mechanic:UpdateEmployee")
AddEventHandler("codem-mechanic:UpdateEmployee", function(job, key, val)
    local src = source
    UpdateEmployee(src, job, key, val)
end)

RegisterServerEvent("codem-mechanic:RemoveEmployee")
AddEventHandler("codem-mechanic:RemoveEmployee", function(job)
    local src = source
    RemoveEmployee(src, job)
end)


RegisterServerEvent("codem-mechanic:CreateMechanicData")
AddEventHandler("codem-mechanic:CreateMechanicData", function()
    local src = source
    local job = GetJob(src)
    CreateMechanicData(job)
end)

RegisterServerEvent("codem-mechanic:DragItem")
AddEventHandler("codem-mechanic:DragItem", function(data)
    local src = source
    if CheckPermission(src, 'accessInventory') then
        DragItem(src, data)
    end
end)

function CheckItem(source, itemData)
    local inventory = GetPlayerInventory(source)
    for _, v in pairs(inventory) do
        if tonumber(itemData.amount) ~= nil and tonumber(v.amount) ~= nil then
            if v.name == itemData.name and tonumber(itemData.amount) <= tonumber(v.amount) then
                return true
            end
        end
    end
    return false
end

function AddItem(src, name, amount, metadata)
    local Player = GetPlayer(src)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if GetResourceState('codem-inventory') ~= 'missing' then
                if exports['codem-inventory']:AddItem(src, name, amount, nil, metadata) then
                    local inventory = GetPlayerInventory(src)
                    TriggerClientEvent("codem-mechanic:UpdateInv", src, inventory)
                    return true
                end
            else
                if Player.canCarryItem(name, amount) then
                    Player.addInventoryItem(name, amount, metadata)
                end
            end
        else
            if GetResourceState('codem-inventory') ~= 'missing' then
                if exports['codem-inventory']:AddItem(src, name, amount, nil, metadata) then
                    local inventory = GetPlayerInventory(src)
                    TriggerClientEvent("codem-mechanic:UpdateInv", src, inventory)
                    return true
                end
            else
                Player.Functions.AddItem(name, amount, nil, metadata)
            end
        end
        local inventory = GetPlayerInventory(src)
        TriggerClientEvent("codem-mechanic:UpdateInv", src, inventory)
    end
end

function canAddItem(src, name, amount)
    local Player = GetPlayer(src)

    if not Player then return false end

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        if GetResourceState('codem-inventory') ~= 'missing' then
            return exports['codem-inventory']:CanCarryItem(src, name, amount)
        else
            return true
        end
    else
        if GetResourceState('codem-inventory') ~= 'missing' then
            return exports['codem-inventory']:CanCarryItem(src, name, amount)
        else
            return true
        end
    end
end

function DeleteItem(source, itemData)
    local Player = GetPlayer(source)
    if CheckItem(source, itemData) then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if GetResourceState('codem-inventory') ~= 'missing' then
                exports["codem-inventory"]:RemoveItem(source, itemData.name, itemData.amount)
            else
                Player.removeInventoryItem(itemData.name, itemData.amount, itemData.metadata, itemData.slot)
            end
        else
            local amount = itemData.amount or itemData.count
            if GetResourceState('codem-inventory') ~= 'missing' then
                exports["codem-inventory"]:RemoveItem(source, itemData.name, amount)
            else
                Player.Functions.RemoveItem(itemData.name, amount, itemData.slot)
            end
        end
        local inventory = GetPlayerInventory(source)
        TriggerClientEvent("codem-mechanic:UpdateInv", source, inventory)
        return true
    end
    return false
end

function TableComp(a, b)              --algorithm is O(n log n), due to table growth.
    if #a ~= #b then return false end -- early out
    local t1, t2 = {}, {}             -- temp tables
    for k, v in pairs(a) do           -- copy all values into keys for constant time lookups
        t1[k] = (t1[k] or 0) + 1      -- make sure we track how many times we see each value.
    end
    for k, v in pairs(b) do
        t2[k] = (t2[k] or 0) + 1
    end
    for k, v in pairs(t1) do                -- go over every element
        if v ~= t2[k] then return false end -- if the number of times that element was seen don't match...
    end
    return true
end

function GetBossItemByName(name, itemName, metadata)
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        for _, v in pairs(mechanic.inventory) do
            if metadata and v.metadata then
                if v.name == itemName and TableComp(v.metadata, metadata) then
                    return v, _
                end
            else
                if v.name == itemName then
                    return v, _
                end
            end
        end
    end
    return false
end

function GetOnlineMechanicEmployees(name)
    local players = {}
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        for _, v in pairs(mechanic.employees) do
            if v.online then
                local player = GetPlayerFromIdentifier(v.identifier)
                if player then
                    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                        table.insert(players, player.source)
                    else
                        table.insert(players, player.PlayerData.source)
                    end
                end
            end
        end
    end
    return players
end

function AddItemToBoss(name, itemData, src)
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        local item, index = GetBossItemByName(name, itemData.name)
        if not item then
            table.insert(mechanic.inventory, itemData)
            local players = GetOnlineMechanicEmployees(name)
            for _, v in pairs(players) do
                TriggerClientEvent("codem-mechanic:BossInventoryItemAdded", v, itemData)
            end
        else
            if item.metadata then
                if item.unique ~= nil and item.unique then
                    table.insert(mechanic.inventory, itemData)
                    local players = GetOnlineMechanicEmployees(name)

                    for _, v in pairs(players) do
                        TriggerClientEvent("codem-mechanic:BossInventoryItemAdded", v, itemData)
                    end
                else
                    mechanic.inventory[index].amount = mechanic.inventory[index].amount + itemData.amount
                    local players = GetOnlineMechanicEmployees(name)
                    for _, v in pairs(players) do
                        TriggerClientEvent("codem-mechanic:BossInventoryItemUpdated", v, mechanic.inventory[index])
                    end
                end
            else
                mechanic.inventory[index].amount = mechanic.inventory[index].amount + itemData.amount
                local players = GetOnlineMechanicEmployees(name)
                for _, v in pairs(players) do
                    TriggerClientEvent("codem-mechanic:BossInventoryItemUpdated", v, mechanic.inventory[index])
                end
            end
        end
        ExecuteSql("UPDATE `codem_mechanic_boss` SET `inventory` = '" ..
            json.encode(mechanic.inventory) .. "' WHERE name = '" .. name .. "'")
    end
end

function RemoveItemFromBoss(name, itemData)
    local mechanic = GetMechanicDataByName(name)
    if mechanic then
        local item, index = GetBossItemByName(name, itemData.name, itemData.metadata)

        if item then
            if tonumber(itemData.amount) <= tonumber(item.amount) then
                local players = GetOnlineMechanicEmployees(name)
                local newAmount = tonumber(item.amount) - tonumber(itemData.amount)
                mechanic.inventory[index].amount = newAmount
                if mechanic.inventory[index].amount <= 0 then
                    for _, v in pairs(players) do
                        TriggerClientEvent("codem-mechanic:BossInventoryItemRemoved", v, mechanic.inventory[index])
                    end
                    table.remove(mechanic.inventory, index)
                else
                    for _, v in pairs(players) do
                        TriggerClientEvent("codem-mechanic:BossInventoryItemUpdated", v, mechanic.inventory[index])
                    end
                end

                ExecuteSql("UPDATE `codem_mechanic_boss` SET `inventory` = '" ..
                    json.encode(mechanic.inventory) .. "' WHERE name = '" .. name .. "'")
                return true
            end
        end
    end
    return false
end

function DragItem(src, data)
    local job = GetJob(src)
    if not Config.MechanicSettings[job] then
        return
    end
    if data.fromInv == 'player' then
        if DeleteItem(src, data) then
            local amount = data.amount or data.count
            AddLog(job, string.format(Config.Locales.PUT_ITEM, GetName(src), amount, data.label))
            local itemData = {
                name = data.name,
                amount = amount,
                metadata = data.metadata,
                label = data.label,
                image = data.image,
            }

            if GetResourceState('codem-inventory') ~= 'missing' then
                itemData.unique = exports["codem-inventory"]:GetItemList()[itemData.name].unique
            end
            AddItemToBoss(job, itemData, src)
        end
    end
    if data.fromInv == 'boss' then
        local mechanic = GetMechanicDataByName(job)
        if mechanic then
            if GetResourceState('codem-inventory') ~= 'missing' then
                local amount = data.amount or data.count
                if canAddItem(src,data.name, amount) then
                    if RemoveItemFromBoss(job, data) then
                        AddLog(job, string.format(Config.Locales.TOOK_ITEM, GetName(src), amount, data.label))
                        AddItem(src, data.name, data.amount, data.metadata)
                    end
                end
            else
                if canAddItem(src,data.name, data.amount) then
                    if RemoveItemFromBoss(job, data) then
                        local amount = data.amount or data.count
                        AddLog(job, string.format(Config.Locales.TOOK_ITEM, GetName(src), amount, data.label))
                        AddItem(src, data.name, amount, data.metadata)
                    end
                end
            end
        end
    end
end

function SetJob(src, job, grade)
    local Player = GetPlayer(src)
    if Player then
        local newGrade = grade or 0
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if Core.DoesJobExist(job, newGrade) then
                Player.setJob(job, newGrade)
            end
        else
            if Core.Shared.Jobs[job] and Core.Shared.Jobs[job].grades[tostring(newGrade)] then
                Player.Functions.SetJob(job, newGrade)
            end
        end
    end
end

local key = nil
Citizen.CreateThread(function()
    key = "CODEM" .. math.random(10000, 999999999) .. "saas" .. math.random(10000, 999999999) .. "KEY"
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    RegisterCallback('codem-mechanic:getKey', function(source, cb)
        cb(key)
    end)
end)

exports('GetKey', function()
    return key
end)

RegisterServerEvent('codem-mechanic:giveMoney', function(clientkey, money)
    local src = source
    if key ~= clientkey then
        DropPlayer(src, 'Codem Mechanic Event Trigger.')
        return
    end
    AddMoney(src, tonumber(money))
end)

function AddMoney(source, amount)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            Player.addMoney(amount)
        else
            Player.Functions.AddMoney("cash", amount)
        end
    end
end

function RemoveMoney(source, amount)
    local success = false
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if Player.getMoney() >= amount then
                Player.removeMoney(amount)
                success = true
            end
        else
            if Player.Functions.RemoveMoney("cash", amount) then
                success = true
            end
        end
    end
    return success
end

function RemoveMoneyBank(source, amount)
    local success = false
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if Player.getAccount('bank').money >= amount then
                Player.removeAccountMoney('bank', amount)
                success = true
            end
        else
            if Player.Functions.RemoveMoney("bank", amount) then
                success = true
            end
        end
    end
    return success
end

RegisterServerEvent("codem-mechanic:PromotePlayer")
AddEventHandler("codem-mechanic:PromotePlayer", function(identifier)
    local src = source
    local job, grade = GetJob(src)
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        if mechanic.bossGradeLevel == grade then
            local Player = GetPlayerFromIdentifier(identifier)
            if Player then
                local targetSrc = (Config.Framework == 'esx' or Config.Framework == 'oldesx') and Player.source or
                    Player.PlayerData.source
                local targetJob, targetGrade = GetJob(targetSrc)
                if targetJob == job and grade > targetGrade then
                    AddLog(job, string.format(Config.Locales.PROMOTED, GetName(src), GetName(targetSrc)))
                    SetJob(targetSrc, targetJob, targetGrade + 1)
                end
            else
                TriggerClientEvent('codem-mechanic:notification', src, Config.Locales.PLAYER_OFFLINE)
            end
        end
    end
end)

RegisterServerEvent("codem-mechanic:DemotePlayer")
AddEventHandler("codem-mechanic:DemotePlayer", function(identifier)
    local src = source
    local job, grade = GetJob(src)
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        if mechanic.bossGradeLevel == grade then
            local Player = GetPlayerFromIdentifier(identifier)
            if Player then
                local targetSrc = (Config.Framework == 'esx' or Config.Framework == 'oldesx') and Player.source or
                    Player.PlayerData.source
                local targetJob, targetGrade = GetJob(targetSrc)
                if targetJob == job and grade > targetGrade then
                    AddLog(job, string.format(Config.Locales.DEMOTED, GetName(src), GetName(targetSrc)))

                    SetJob(targetSrc, targetJob, targetGrade - 1)
                end
            else
                TriggerClientEvent('codem-mechanic:notification', src, Config.Locales.PLAYER_OFFLINE)
            end
        end
    end
end)

function CheckPermission(src, name)
    local job, grade = GetJob(src)
    local mechanic = GetMechanicDataByName(job)
    local myRankData = false
    if mechanic then
        local ranks = GetJobRanks(source)
        for _, v in pairs(ranks) do
            if tonumber(v.grade) == tonumber(grade) then
                myRankData = v
            end
        end
        if myRankData and (myRankData.permissions[name] or myRankData.isBoss) then
            return true
        end
    end
    return false
end

function ChangePermission(src, rankLevel, permissionName, allow)
    local job, grade = GetJob(src)
    local mechanic = GetMechanicDataByName(job)

    if mechanic then
        if not mechanic.permissions[tostring(rankLevel)] then
            mechanic.permissions[tostring(rankLevel)] = {
                [permissionName] = allow,
            }
        else
            mechanic.permissions[tostring(rankLevel)][permissionName] = allow
        end
        ExecuteSql("UPDATE `codem_mechanic_boss` SET `permissions` = '" ..
            json.encode(mechanic.permissions) .. "' WHERE name = '" .. job .. "'")
        local players = GetOnlineMechanicEmployees(job)
        for _, v in pairs(players) do
            TriggerClientEvent("codem-mechanic:UpdateRanks", v)
        end
    end
end

RegisterServerEvent("codem-mechanic:ChangePermission")
AddEventHandler("codem-mechanic:ChangePermission", function(rankLevel, permissionName, allow)
    local src = source
    local job, grade = GetJob(src)
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        if mechanic.bossGradeLevel == grade then
            ChangePermission(src, rankLevel, permissionName, allow)
            if allow then
                AddLog(job, string.format(Config.Locales.GRANTED_PERMISSION, GetName(src), permissionName))
            else
                AddLog(job, string.format(Config.Locales.REMOVED_PERMISSION, GetName(src), permissionName))
            end
        else
            TriggerClientEvent('codem-mechanic:notification', src, Config.Locales.NOT_ALLOWED_TO_DO_THIS)
        end
    end
end)

RegisterServerEvent("codem-mechanic:FirePlayer")
AddEventHandler("codem-mechanic:FirePlayer", function(identifier)
    local src = source
    local job, grade = GetJob(src)
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        if mechanic.bossGradeLevel == grade then
            local Player = GetPlayerFromIdentifier(identifier)
            if Player then
                local targetSrc = (Config.Framework == 'esx' or Config.Framework == 'oldesx') and Player.source or
                    Player.PlayerData.source
                local targetJob, targetGrade = GetJob(targetSrc)
                if targetJob == job and grade > targetGrade then
                    AddLog(job, string.format(Config.Locales.FIRED, GetName(src), GetName(targetSrc)))
                    SetJob(targetSrc, 'unemployed')
                end
            else
                TriggerClientEvent('codem-mechanic:notification', src, Config.Locales.PLAYER_OFFLINE)
            end
        end
    end
end)

RegisterServerEvent("codem-mechanic:HireNewPlayer")
AddEventHandler("codem-mechanic:HireNewPlayer", function(id)
    local src = source
    local job, grade = GetJob(src)
    local mechanic = Config.MechanicSettings[job]
    if mechanic then
        local Player = GetPlayer(tonumber(id))
        if Player then
            if CheckPermission(src, 'addNewEmployee') then
                AddLog(job, string.format(Config.Locales.HIRED, GetName(src), GetName(id)))

                SetJob(tonumber(id), job)
            end
        else
            TriggerClientEvent('codem-mechanic:notification', src, Config.Locales.PLAYER_OFFLINE)
        end
    end
end)
