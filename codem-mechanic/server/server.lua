local moduleData = {}
moduleData.Avatars = {}
local registeredCallbacks = {}

offSetData = {}

local registerServerEvent = RegisterServerEvent
local triggerClientEvent = TriggerClientEvent

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
