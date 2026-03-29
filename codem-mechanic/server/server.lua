local moduleData = {}
moduleData.Avatars = {}
local registeredCallbacks = {}
Core = nil

offSetData = {}

local registerServerEvent = RegisterServerEvent
local triggerClientEvent = TriggerClientEvent

CreateThread(function()
    Core, Config.Framework = GetCore()
end)

function RegisterCallback(name, cb)
    registeredCallbacks[name] = cb
end

registerServerEvent("codem-mechanic:triggerServerCallback")
AddEventHandler("codem-mechanic:triggerServerCallback", function(name, requestId, ...)
    local src = source
    local callback = registeredCallbacks[name]
    if not callback then
        triggerClientEvent("codem-mechanic:serverCallback", src, requestId, nil)
        return
    end

    callback(src, function(...)
        triggerClientEvent("codem-mechanic:serverCallback", src, requestId, ...)
    end, ...)
end)

function GetPlayer(source)
    while Core == nil do
        Wait(0)
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        return Core.GetPlayerFromId(source)
    end

    return Core.Functions.GetPlayer(source)
end

function GetIdentifier(source)
    local player = GetPlayer(source)
    if not player then
        return nil
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        return player.getIdentifier()
    end

    return player.PlayerData.citizenid
end

function GetJob(source)
    local player = GetPlayer(source)
    if not player then
        return false
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        local playerJob = player.getJob()
        return playerJob.name, playerJob.grade
    end

    return player.PlayerData.job.name, player.PlayerData.job.grade.level
end

function GetName(source)
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        local player = GetPlayer(source)
        if not player then
            return "Unknown"
        end
        return (player.getName and player.getName()) or player.getIdentifier() or "Unknown"
    end

    local player = GetPlayer(source)
    if player and player.PlayerData and player.PlayerData.charinfo then
        return (player.PlayerData.charinfo.firstname or "") .. " " .. (player.PlayerData.charinfo.lastname or "")
    end

    return GetPlayerName(source) or "Unknown"
end

function AddMoney(source, amount)
    local player = GetPlayer(source)
    if not player then
        return false
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        player.addMoney(amount)
        return true
    end

    player.Functions.AddMoney("cash", amount)
    return true
end

function RemoveMoney(source, amount)
    local player = GetPlayer(source)
    if not player then
        return false
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        if player.getMoney() < amount then
            return false
        end
        player.removeMoney(amount)
        return true
    end

    if player.Functions.GetMoney("cash") < amount then
        return false
    end
    player.Functions.RemoveMoney("cash", amount)
    return true
end

function RemoveMoneyBank(source, amount)
    local player = GetPlayer(source)
    if not player then
        return false
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        local bank = player.getAccount("bank").money
        if bank < amount then
            return false
        end
        player.removeAccountMoney("bank", amount)
        return true
    end

    if player.Functions.GetMoney("bank") < amount then
        return false
    end
    player.Functions.RemoveMoney("bank", amount)
    return true
end

function GetPlayerInventory(source)
    local player = GetPlayer(source)
    if not player then
        return {}
    end

    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        return player.inventory or {}
    end

    return (player.PlayerData and player.PlayerData.items) or {}
end

local function handleShowOtherBill(billData)
    local targetPlayerId = tonumber(billData.plyid)
    if targetPlayerId then
        triggerClientEvent("codem-mechanic:sendShowBill", targetPlayerId, billData)
    end
end

registerServerEvent("codem-mechanic:showOtherBill", handleShowOtherBill)

registerServerEvent("codem-mechanic:getNearbyPlayers", function(playersData)
    local sourcePlayerId = source
    local nearbyPlayersList = {}

    for _, playerInfo in pairs(playersData) do
        local otherPlayerId = playerInfo.id
        if sourcePlayerId ~= otherPlayerId then
            local playerName = GetName(tonumber(playerInfo.id))
            local playerAvatar = GetDiscordAvatar(tonumber(playerInfo.id))

            if not playerAvatar then
                playerAvatar = Config.ExampleProfilePicture
            end

            table.insert(nearbyPlayersList, {
                name = playerName,
                id = otherPlayerId,
                avatar = playerAvatar
            })
        end
    end

    if #nearbyPlayersList > 0 then
        triggerClientEvent("codem-mechanic:setNearbyPlayers", sourcePlayerId, nearbyPlayersList)
    end
end)

local discordAuthHeader = "Bot " .. bot_Token

local function DiscordRequest(method, endpoint, body)
    local responseResult = nil
    local fullUrl = "https://discordapp.com/api/" .. endpoint

    local function httpCallback(statusCode, responseData, responseHeaders)
        responseResult = {
            data = responseData,
            code = statusCode,
            headers = responseHeaders
        }
    end

    local bodyString = ""
    -- The original code checks if #body > 0 and then encodes.
    -- If body is an empty table {}, #body is 0, so bodyString remains "".
    -- If body is a non-empty table, it's encoded. If json.encode fails, bodyString becomes "".
    if body and next(body) then
        bodyString = json.encode(body) or ""
    end

    local headers = {
        ["Content-Type"] = "application/json",
        Authorization = discordAuthHeader
    }

    PerformHttpRequest(fullUrl, httpCallback, method, bodyString, headers)

    while responseResult == nil do
        Citizen.Wait(0)
    end

    return responseResult
end

DiscordRequest = DiscordRequest

local function GetDiscordAvatar(playerId)
    local discordId = nil
    local avatarUrl = nil

    local playerIdentifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(playerIdentifiers) do
        if string.match(identifier, "discord:") then
            discordId = string.gsub(identifier, "discord:", "")
            break
        end
    end

    if discordId then
        local cachedAvatar = moduleData.Avatars[discordId]
        if cachedAvatar ~= nil then
            return cachedAvatar
        end

        local endpoint = string.format("users/%s", discordId)
        local response = DiscordRequest("GET", endpoint, {})

        if response.code == 200 then
            local userData = json.decode(response.data)
            if userData and userData.avatar then
                local avatarHash = userData.avatar
                local isAnimated = (avatarHash:sub(1, 1) ~= nil and avatarHash:sub(2, 2) == "_")

                if isAnimated then
                    avatarUrl = string.format("https://media.discordapp.net/avatars/%s/%s.gif", discordId, avatarHash)
                else
                    avatarUrl = string.format("https://media.discordapp.net/avatars/%s/%s.png", discordId, avatarHash)
                end
            end
        end

        moduleData.Avatars[discordId] = avatarUrl
        return avatarUrl
    end

    return nil
end

GetDiscordAvatar = GetDiscordAvatar
